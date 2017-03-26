module ResponseTimeViewer
  module Rails
    class Engine < ::Rails::Engine
      isolate_namespace ResponseTimeViewer::Rails
    end
  end
end
