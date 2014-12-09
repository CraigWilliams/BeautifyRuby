module RBeautify
  class TabSize
    DEFAULT_TAB_SIZE = 6

    def initialize(config)
      @tab_size = config['tab_size'].to_i
    end

    def tab_size
      @tab_size == 0 ? DEFAULT_TAB_SIZE : @tab_size
    end

  end
end
