module ApplicationHelper
    def construct_message(params)
        "code=#{params['code']}&shop=#{params['shop']}&state=#{params['state']}&timestamp=#{params['timestamp']}"
    end
end
