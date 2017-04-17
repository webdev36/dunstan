module ApplicationHelper
  def post_data(uri, data)
    host = Rails.application.secrets.api_host
    response_data = {}
    return response_data unless ttd_auth.present?
    RestClient.post(host+uri, data.to_json, :content_type => :json, :accept => :json){ |response, request, result, &block|
      case response.code
      when 200
        p "It worked !"
        response_data = JSON.parse(response.body)
      when 400
        p "400 BAD request HTTP error code"
        response_data = JSON.parse(response.body)
        p response.body
      when 403
        p response.body
      when 404
        p "404 BAD request HTTP error code"
        response_data = JSON.parse(response.body)
        p response.body
      when 500
        p "500 Internal Server Error"
        response_data = JSON.parse(response.body)
        p response.body
      else
        p "post response.code>>>>>>>#{response.code}"
      end
    }
    response_data
  end

  def put_data(uri, data)
    ttd_auth = get_auth_token
    host = Rails.application.secrets.api_host
    response_data = {}
    return response_data unless ttd_auth.present?
    RestClient.put(host+uri, data.to_json, :content_type => :json, :accept => :json, :"Authorization" => ttd_auth){ |response, request, result, &block|
      case response.code
      when 200
        p "It worked !"
        response_data = JSON.parse(response.body)
      when 400
        p "400 BAD request HTTP error code"
        response_data = JSON.parse(response.body)
        p response.body
      when 403
        p "403 BAD request HTTP error code"
        p response.body
        response_data = JSON.parse(response.body)
      when 404
        p "404 BAD request HTTP error code"
        p response.body
        response_data = JSON.parse(response.body)
      when 500
        p "500 Internal Server Error"
        response_data = JSON.parse(response.body)
      else
        # response.return!(request, result, &block)
        p "response.code>>>>>>>#{response.code}"
      end
    }
    response_data
  end

  def get_data(uri, data = {})
    ttd_auth = get_auth_token
    host = Rails.application.secrets.api_host
    response_data = {}
    return response_data unless ttd_auth.present?
    RestClient.get(host + uri, {:"Authorization" => ttd_auth}){ |response, request, result, &block|
      case response.code
      when 200
        p "It worked !"
        response_data = JSON.parse(response.body)
      when 403
        p "403 error"
        response_data = JSON.parse(response.body)
      when 500
        p "500 Internal Server Error"
        response_data = JSON.parse(response.body)
      else
        p "response.code>>>>>>>#{response.code}"
      end
    }
    response_data
  end

  def destroy_data(uri)
    ttd_auth = get_auth_token
    host = Rails.application.secrets.api_host
    response_data = {}
    return response_data unless ttd_auth.present?
    RestClient.delete(host + uri, {:"Authorization" => ttd_auth}){ |response, request, result, &block|
      case response.code
      when 200
        p "It worked !"
        response_data = JSON.parse(response.body)
      when 403
        p "403 error"
        response_data = JSON.parse(response.body)
      when 500
        p "500 Internal Server Error"
        response_data = JSON.parse(response.body)
      else
        p "response.code>>>>>>>#{response.code}"
      end
    }
    response_data
  end
end
