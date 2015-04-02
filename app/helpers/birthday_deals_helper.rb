module BirthdayDealsHelper
  def birthday_deal_state_link(birthday_deal)
  #   out = ''
  #   if current_user.superadmin? && birthday_deal.submitted?
  #     if birthday_deal.approved?
  #       out.concat link_to ''
  #     out.concat link_to 'Approve', approve_dashboard_location_birthday_deal_path(@location, birthday_deal), remote: true, method: :put
  #   else
  #     if birthday_deal.submitted?
  #       out.concat link_to 'Withdraw', withdraw_dashboard_location_birthday_deal_path(@location, birthday_deal), remote: true, method: :put
  #     else
  #       out.concat link_to 'Submit for approval', submit_for_approval_dashboard_location_birthday_deal_path(@location, birthday_deal), remote: true, method: :put
  #     end
  #   end
  #   raw(out)
  end

  def password_label
    "Password <a href=#{customer_login_path()} class='forgot_password'>?</a>".html_safe
  end

  def approval_buttons(birthday_deal)
    out = ''
    if birthday_deal.unapproved?

      if current_user.superadmin?
        out.concat button_to 'Approve', approve_dashboard_birthday_deal_path(birthday_deal.id), remote: true, method: :put
      else
        out.concat button_to 'Submit for Approval', submit_for_approval_dashboard_birthday_deal_path(birthday_deal.id), remote: true, method: :put
      end

    elsif birthday_deal.pending_approval?

      if current_user.superadmin?
        out.concat button_to 'Approve', approve_dashboard_birthday_deal_path(birthday_deal.id), remote: true, method: :put
        out.concat button_to 'Reject', reject_dashboard_birthday_deal_path(birthday_deal.id), remote: true, method: :put
      else
        out.concat button_to 'Withdraw', withdraw_dashboard_birthday_deal_path(birthday_deal.id), remote: true, method: :put
      end

    elsif birthday_deal.approved?

      if current_user.superadmin?
        out.concat button_to 'Reject', reject_dashboard_birthday_deal_path(birthday_deal.id), remote: true, method: :put
      else
        out.concat button_to 'Withdraw', withdraw_dashboard_birthday_deal_path(birthday_deal.id), remote: true, method: :put
      end

    end

    if birthday_deal.archived?
      out = ''
    else
      out.concat button_to 'Archive', dashboard_birthday_deal_path(birthday_deal.id), remote: true, method: :delete, data: { confirm: 'Are you sure?' }
    end

    raw(out)
  end

  def single(vouchers)
    out = ''
    display = 'inline-block'
    vouchers.each { |voucher|
      box = rand(9)+1
      apple = content_tag_for :a, voucher, class: "birthday-box", style: "display:#{display};", :data => { box: box} do
        image_tag "birthday_deals/box-#{box}-closed.png", class: "box-#{box}"
      end
      out.concat apple
      display='none'
    }
    out.html_safe 
  end

  def pyramid(vouchers)
    out = ''
    count = vouchers.count
    i = 0
    tri = 0
    index = 0
    until tri >= count
      result = tri
      index = i
      tri = i*(i+1)/2
      i += 1
    end
    index.times { |i|
      i.times { |j|
        box = rand(9)+1
        apple = content_tag_for :a, vouchers.to_a.pop, href: '#', class: "birthday-box", :data => { box: box} do
          image_tag "birthday_deals/box-#{box}-closed.png", class: "box-#{box}"
        end
        out.concat apple
      }
      out.concat "<br />"
    }
    out.concat "<div id='more-boxes'>"
    vouchers.each { |voucher|
      box = rand(9)+1
      apple = content_tag_for :a, voucher, class: "birthday-box", :data => { box: box} do
        image_tag "birthday_deals/box-#{box}-closed.png", class: "box-#{box}"
      end
      out.concat apple
    }
    out.concat "</div>"
    out.html_safe

  end
end
