require 'order_helper'
require 'combo_helper'

def define_contracts
  @ib = IB::Connection.new OPTS[:connection].merge(:logger => mock_logger)
  @contracts = {
    :stock => IB::Symbols::Stocks[:wfc],
    :butterfly => butterfly('GOOG', '201301', 'CALL', 500, 510, 520)
  }
  close_connection
end

describe 'Attached Orders', :connected => true, :integration => true do

  before(:all) do
    verify_account
    define_contracts
  end

  # Testing different combinations of Parent + Attached Orders:
  [
    [:stock, 100, 'DAY', 'LMT', 9.13, 20.0], # Parent + takeprofit target
    #[:stock, 100, 'DAY', 'STP', 9.13, 0.0, 8.0], # Parent + stoploss
    #[:stock, 100, 'GTC', 'LMT', 9.13, 20.0], # GTC Parent + target
    [:butterfly, 10, 'DAY', 'LMT', 0.05, 1.0], # Combo Parent + target
    #[:butterfly, 10, 'GTC', 'LMT', 0.05, 1.0], # GTC Combo Parent + target
    #[:butterfly, 100, 'GTC', 'STPLMT', 0.05, 0.05, 1.0], # GTC Combo Parent + stoplimit target
  ].each do |(contract, qty, tif, attach_type, limit_price, attach_price, aux_price)|
    context "#{tif} BUY (#{contract}) limit order with attached #{attach_type} SELL" do
      let(:contract_type) { contract }

      before(:all) do
        @ib = IB::Connection.new OPTS[:connection].merge(:logger => mock_logger)
        @ib.wait_for :NextValidId
        @ib.clear_received # to avoid conflict with pre-existing Orders

        #p [contract, qty, tif, attach_type, limit_price, attach_price, aux_price]
        @contract = @contracts[contract]
        place_order @contract,
          :total_quantity => qty,
          :limit_price => limit_price,
          :tif => tif,
          :transmit => false

        @ib.wait_for :OpenOrder, :OrderStatus, 2
      end

      after(:all) { close_connection }

      it 'does not transmit original Order before attach' do
        @ib.received[:OpenOrder].should have_exactly(0).order_message
        @ib.received[:OrderStatus].should have_exactly(0).status_message
      end

      context "Attaching #{attach_type} order" do
        before(:all) do
          @attached_order = IB::Order.new :limit_price => attach_price,
            :aux_price => aux_price || 0,
            :total_quantity => qty,
            :side => :sell,
            :tif => tif,
            :order_type => attach_type,
            :parent_id => @local_id_placed

          @local_id_attached = @ib.place_order @attached_order, @contract
          @local_id_after = @ib.next_local_id
          @ib.wait_for [:OpenOrder, 3], [:OrderStatus, 3], 4
        end

        it_behaves_like 'Placed Order'
      end

      context 'When original Order cancels' do
        it 'attached takeprofit is cancelled implicitly' do
          @ib.send_message :RequestOpenOrders
          @ib.wait_for :OpenOrderEnd
          @ib.received[:OpenOrder].should have_exactly(0).order_message
          @ib.received[:OrderStatus].should have_exactly(0).status_message
        end
      end

    end
  end
end # Orders
