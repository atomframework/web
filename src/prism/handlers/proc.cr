require "http/server/handler"

module Prism::Handlers
  # `HTTP::Handler` which calls the *proc* on each `#call`.
  #
  # ```
  # secret = Prism::Handlers::Proc.new do |handler, context|
  #   if context.request.query_params.to_h["secret"]?.try &.== ENV["SECRET"]
  #     handler.call_next(context)
  #   else
  #     context.response.status_code = 403
  #   end
  # end
  # ```
  class Proc
    include HTTP::Handler

    @proc : ::Proc(self, HTTP::Server::Context, Void)

    # Initialize a new handler which will call *proc* on `#call`. Do not forget to call `handler.call_next(context)`.
    def initialize(&proc : self, HTTP::Server::Context -> _)
      @proc = proc
    end

    # :nodoc:
    def call(context)
      @proc.call(self, context)
    end
  end
end
