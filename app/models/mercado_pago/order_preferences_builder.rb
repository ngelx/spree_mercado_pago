module MercadoPago
  class OrderPreferencesBuilder
    include ActionView::Helpers::TextHelper
    include ActionView::Helpers::SanitizeHelper
    include Spree::ProductsHelper

    def initialize(order, payment, callback_urls, payer_data=nil)
      @order = order
      @payment = payment
      @callback_urls = callback_urls
      @payer_data = payer_data
    end

    def preferences_hash
      {
        external_reference: @payment.identifier,
        back_urls: @callback_urls,
        payer: @payer_data,
        items: generate_items
      }
    end


  private

    def generate_items
      items = []

      items += @order.line_items.collect do |line_item|
        {
            :title => line_item_description_text(line_item.variant.product.description),
            :unit_price => line_item.price.to_f,
            :quantity => line_item.quantity,
            :currency_id => 'ARS'
        }
      end

      items << {
        :title => 'Costo de envío',
        :unit_price => @order.ship_total.to_f,
        :quantity => 1,
        :currency_id => 'ARS'
      }

      items
    end
  end
end