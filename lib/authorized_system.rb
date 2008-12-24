module AuthorizedSystem
  protected
    # Inclusion hook to make #is_owner?
    # available as ActionView helper methods.
    def self.included(base)
      base.send :helper_method, :is_owner?
    end

    # Filter method to enforce a login requirement.
    def must_be_owner
      is_owner?
    end

    # Returns true or false if the user is owner of current model or not
    def is_owner?(model = nil)
      model = (self.controller_name.singularize.camelize.constantize).find(params[:id]) if model.nil?

      if not model.has_attribute?(:user_id)
        raise "Model #{model.class_to_s} has no connection with User"
      end

      if session[:user_id] == model.user_id
        return true
      end

      return false
    end
end
