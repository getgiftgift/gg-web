module ApplicationHelper
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  
  def display_price(price)
    return nil unless price
    if ((price*100).divmod(100))[1] == 0
      "$#{price.to_int}"
    else
      number_to_currency(price)
    end
  end

  def display_city_state(city, state)
    city_state = ""
    if city and not city.empty?
      city_state << city
      if state and not state.empty?
        city_state << ", #{state}"
      end
    elsif state and not state.empty?
      city_state << state
    end
    city_state
  end

  def display_full_location(street1, street2, city, state, postal_code)
    location = ""
    if street1 and not street1.empty?
      location << street1
    end
    if street2 and not street2.empty?
      location << " #{street2}"
    end

    location << " #{display_city_state(city, state)}"

    if postal_code and not postal_code.empty?
      location << " #{postal_code}"
    end
    location
  end

  def display_company_location(company)
    display_full_location(company.street1, company.street2, company.city, company.state, company.postal_code)
  end

  def alternate_table_row(str1='colored_row', str2='blank_row')
    @alternating_row = false if @alternating_row.nil?
    @alternating_row = !@alternating_row
    @alternating_row ? str1 : str2        
  end

end
