module Hanami
  module Events
    # Mixin that extends class by `subscribe_to` method.
    #
    # @example
    # $events = Hanami::Events.initialize(:memory)
    #
    # class WelcomeMailer
    #   include Hanami::Events::Mixin
    #
    #   subscribe_to $events, 'user.created'
    #
    #   def call(payload)
    #     # send email
    #   end
    # end
    #
    # @since 0.1.0
    #
    # @api public
    module Mixin
      def self.included(klass)
        klass.extend(ClassMethods)
      end

      module ClassMethods
        def subscribe_to(event_bus, *event_names)
					klass = self
					event_names.each do |event_name|
						event_bus.subscribe(event_name) { |payload| klass.new.(event_name, payload) }
					end
				end
      end
    end
  end
end
