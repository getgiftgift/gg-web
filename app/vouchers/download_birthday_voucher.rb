class DownloadBirthdayVoucher < Prawn::Document
require 'prawn'
require 'prawn/table'
require 'barby'
require 'barby/barcode/code_128'
require 'barby/outputter/prawn_outputter'
include ActionView::Helpers::SanitizeHelper
include ActionView::Helpers::AssetTagHelper

def clean_string(in_string)
  strip_tags(in_string.gsub(/\&nbsp\;/,''))
end

def to_pdf(voucher)
  # Generates a box with a top-left of [100,600] and a top-right of [300,600]
    # The box automatically expands as the cursor moves down the page. Notice
    # that the final coordinates are outlined by a top and bottom line drawn
    # relatively using calculations from +bounds+.
    #
    # logo = "#{Rails.root}/public/images/birthday-logo.png"
    logo = "#{Rails.root}/app/assets/images/birthday_deals/voucher-birthday-logo.png"

    birthday_deal = voucher.birthday_deal
    bounding_box [20,bounds.height], :width => 460 do
      bounding_box [20,bounds.height], :width => 460 do

        move_down 10
        indent(10) do
          bounding_box [0,0], :width => 440 do
            image logo, :at => [0, 0], scale: 0.5
          end


          move_down 144
          bounding_box [0,0], :width => 420 do

            move_down 10
            
            text "#{voucher.hook}"
            move_down 20

            text "Recipient: ", :style => :bold
            text voucher.user.full_name
            text "Birthday: #{voucher.user.birthday}"
            move_down 15

            text "Redeem at: ", :style => :bold
            move_down 15


            table_data = [[],[],[],[],[]]
            col_num = 0
            column_widths = {}
            c_loc = birthday_deal.company_locations
            unless c_loc.empty?
              while col_num <= ((c_loc.size > 2 ) ? 1 : (c_loc.size - 1))
                loc = c_loc[col_num]
                name = (loc.name.nil? || loc.name.empty?) ? birthday_deal.company.name : loc.name
                i = 0
                table_data[i][col_num] = "<b>#{name}</b>"
                i+=1
                table_data[i][col_num] = loc.street1
                i+=1
                if (!loc.street2.empty?)
                  table_data[i][col_num] = loc.street2
                  i+=1
                end
                table_data[i][col_num] = "#{loc.city}, #{loc.state} #{loc.postal_code}"
                i+=1
                table_data[i][col_num] = loc.phone
                column_widths[col_num] = 200
                col_num += 1
              end
              indent(10) do
                table(table_data,  :column_widths => column_widths, :cell_style => { :inline_format => true, :border_widths => 0, :padding => 0, :padding_right => 25, :size => 10 })
              end
            end


            if c_loc.size > 2

              move_down 15

              table_data = [[],[],[],[],[]]
              col_num = 0
              while (col_num + 2) <= ((c_loc.size > 4) ? 3 : (c_loc.size - 1))
                new_num = col_num + 2
                loc = c_loc[new_num]
                name = (loc.name.nil? || loc.name.empty?) ? birthday_deal.company.name : loc.name
                i = 0
                table_data[i][col_num] = "<b>#{name}</b>"
                i+=1
                table_data[i][col_num] = loc.street1
                i+=1
                if (!loc.street2.empty?)
                  table_data[i][col_num] = loc.street2
                  i+=1
                end
                table_data[i][col_num] = "#{loc.city}, #{loc.state} #{loc.postal_code}"
                i+=1
                table_data[i][col_num] = loc.phone
                column_widths[col_num] = 200
                col_num += 1
              end
               indent(10) do
                 table(table_data, :column_widths => column_widths, :cell_style => { :inline_format => true, :border_widths => 0, :padding => 0, :padding_right => 25, :size => 10 })
               end
            end
            move_down 30

            #text "Expires on: ", :style => :bold
            #text big_deal.expires_on
            #move_down 1

            text "Important Details", :style => :bold
            text clean_string(birthday_deal.restrictions)
            move_down 10

            text "Valid: #{voucher.valid_on.strftime('%B %d, %Y')}", :size => 12, :style => :bold
            text "Good Thru: #{voucher.good_through.strftime('%B %d, %Y')}", :size => 12, :style => :bold
            move_down 80

            padded_ver_num = voucher.plain_verification_number
            padded_ver_num = '0' + padded_ver_num if padded_ver_num.length.odd?

            barcode = Barby::Code128C.new(padded_ver_num)
            barcode.annotate_pdf(self, :height => 60, :xdim => 1.5, :x => 125)

            move_down 50

            text "Verification number: #{voucher.dashed_verification_number}", :size => 14, :style => :bold
            text "This is an example voucher and is not valid" if voucher.user.test_user?

            stroke_color "aaaaaa"

          end
        end
        move_down 10

        stroke_color "333333"
        stroke do
          stroke_bounds
        end
      end
      bounding_box [0,0], :width => 420 do

        move_down 20
        indent(30) do

          text "How to redeem this", :style => :bold
          if birthday_deal.how_to_redeem
            text clean_string(birthday_deal.how_to_redeem), size: 8
          else
            text "Bring this voucher in and present it to the merchant prior to purchase."
          end
          text "Merchant will check ID upon redemption.  Photo ID showing required to validate birthday.", size: 8
        end
      end
    end
    move_down 20


  render
end
end

