module React
  module ServerRendering
    class RouterRenderer < React::ServerRendering::SprocketsRenderer
      def render(component_name, props, prerender_options)
        if !prerender_options[:prerender_location]
          super(component_name, props, prerender_options)
        else
          render_function = prerender_options.fetch(:render_function, 'renderToString')
          location = prerender_options[:prerender_location]
          js_code = <<-JS
            (function () {
              #{before_render(component_name, props, prerender_options)}
              var result = '';
              ReactRouter.run(#{component_name}, #{location.to_json}, function (Handler) {
                result = React.#{render_function}(React.createElement(Handler, #{props.to_json}));
              });
              #{after_render(component_name, props, prerender_options)}
              return result;
            })()
          JS
          @context.eval(js_code).html_safe
        end
      rescue ExecJS::ProgramError => err
        raise React::ServerRendering::PrerenderError.new(component_name, props, err)
      end
    end
  end
end
