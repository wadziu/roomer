# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def error_messages_for(*params)
    object = instance_variable_get("@#{params[0]}")
    return nil if object.nil? or object.errors.empty?
    content_tag('ul', 
                object.errors.full_messages.collect { |msg| 
                  content_tag('li', msg) 
                },
                :class => 'mini-error'
    )
  end
end
