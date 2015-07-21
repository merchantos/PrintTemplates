{#
                            ***Begin Custom Options***
Set any of the options in this section from 'false' to 'true' in order to enable them in the template
#}

{% set chrome_right_margin_fix = false %}       {# Fixes a potential issue where the right side of receipts are cut off in Chrome #}
{% set firefox_margin_fix = false %}            {# Fixes issue with margins cutting off when printing on a letter printer on a Mac #}

{# Item Lines #}

{% set per_line_discount = false %}             {# Displays Discounts on each Sale Line #}
{% set per_line_subtotal = false %}             {# Displays Subtotals for each Sale Line (ex. 1 x $5.00) #}
{% set per_line_discounted_subtotal = false %}  {# Strikes out original subtotal and replaces it with discounted total #}
{% set per_line_employee = false %}             {# Display Employee for each Sale line #}
{% set show_custom_sku = false %}               {# Adds SKU column for Custom SKU, if available, on each Sale Line #}
{% set show_manufacturer_sku = false %}         {# Adds SKU column for Manufacturer SKU, if available, on each Sale Line #}
{% set show_msrp = false %}                     {# Adds MSRP column for the item's MSRP, if available, on each Sale Line #}

{# Misc. adjustments #}

{% set hide_thank_you = false %}                {# Displays Thank You! Above bottom barcode #}
{% set transaction_item_count = false %}        {# Gives a total quantity of items sold near the bottom of the receipt #}
{% set store_copy_show_lines = false %}         {# Shows Sale Lines on Credit Card Store Copy receipts #}
{% set quote_to_invoice = false %}              {# Changes Quote wording to Invoice in Sales and in Sale Quotes (does not apply to Work Order Quotes) #}
{% set gift_receipt_no_lines = false %}         {# Removes Sale Lines from Gift Receipts #}
{% set hide_barcode = false %}                  {# Removes barcode from bottom of receipts #}
{% set hide_barcode_sku = false %}              {# Remove the System ID from displaying at the bottom of barcdoes #}

{# Customer information #}

{% set display_full_customer_address = false %} {# Displays Customer's full address, if available #}
{% set customer_name_only = false %}            {# Hides all Customer information except for their name #}
{% set show_customer_notes = false %}           {# Displays Notes entered in the Customer's profile #}
{% set company_name_override = false %}         {# Forces the Company Name to be displayed instead of the Customer Name if Company Name is present #}

{# Customer Account  #}

{% set credit_account_signature = false %}      {# Prints Store Copy with signature line on accounts that use an Account Credit (not Deposit) #}
{% set credit_account_agreement = 'I authorize the above charge to my Credit Account.' %}   {# The text that will display with the signature line #}

{% set hide_customer_layaways = false %}        {# Hides Customer Layaway information at the bottom of receipts #}
{% set hide_customer_specialorders = false %}   {# Hides Customer Special Order information at the bottom of receipts #}
{% set hide_customer_workorders = false %}      {# Hides Customer Work Order information at the bottom of receipts #}
{% set hide_customer_credit_account = false %}  {# Hides Customer Credit Account information at the bottom of receipts #}

{# Logos #}

{% set logo_width = '225px' %}                  {# Default width is 225px. A smaller number will scale logo down #}
{% set multi_shop_logos = false %}              {# Allows multiple logos to be added for separate locations when used with options below #}

{#
    Use the following shop_logo_array to enter all of your locations and the link to the logo image that you have uploaded to the internet.
    Enter your EXACT shop name (Case Sensitive!) in the Quotes after the "name": entry and then enter the URL to your logo after the "logo": entry.
    Be sure to set the multi_shop_logos setting above to true in order to have these logos take effect!
#}

{% set shop_logo_array =
    {
        0:{"name":"Example Shop", "logo_url":"http://logo.url.goes/here.jpg"},
        1:{"name":"", "logo_url":""},
        2:{"name":"", "logo_url":""},
        3:{"name":"", "logo_url":""},
        4:{"name":"", "logo_url":""},
        5:{"name":"", "logo_url":""}
    }
%}


{#
                            ***End Custom Options***
#}


{% extends parameters.print ? "printbase" : "base" %}
{% block extrastyles %}


@page {
    margin: 0;
}

body {
    font: normal 10pt 'Helvetica Neue', Helvetica, Arial, sans-serif;
    margin: 0;
    {% if chrome_right_margin_fix == true %}
        margin-right: .13in;
    {% endif %}
    {% if firefox_margin_fix == true %}
        margin: 25px;
    {% endif %}
    padding: 1px; <!-- You need this to make the printer behave -->
}

.store {
    page-break-after: always;
    margin-bottom: 40px;
}

.receipt {
    font: normal 10pt 'Helvetica Neue', Helvetica, Arial, sans-serif;
}

h1 {
    margin: .5em 0 0;
    font-size: 12pt;
    text-align: center;
}

p.date, p.copy {
    font-size: 9pt;
    margin: 0;
    text-align: center;
}

p.details {
    font-size: 10pt;
    text-align: left;
}

h2 {
    border-bottom: 1px solid black;
    text-transform: uppercase;
    font-size: 10pt;
    margin: .5em 0 0;
}

.header {
    text-align: center;
}

.header h3 {
    font-size: 12pt;
    margin: 0;
}

.header img {
    display: block;
    margin: 8px auto 4px;
    text-align: center;
}

table {
    margin: 0 0;
    width: 100%;
    border-collapse:collapse;
}

table thead th { text-align: left; }

table tbody th {
    font-weight: normal;
    text-align: left;
}

table td.amount, table th.amount {
    text-align: right;
    white-space: nowrap
}

table td.quantity, table th.quantity {
    text-align: center;
    white-space: nowrap;
}

table td.sku, table th.sku {
    padding-right: 10px;
    text-align: center;
    white-space: nowrap;
}

table th.description {
    width: 100%;
}

table td.amount {
    white-space: nowrap;
    padding-left: 10px;
}

table.totals { text-align: right; }
table.payments { text-align: right; }
table.spacer { margin-top: 1em; }
table tr.total td { font-weight: bold; }

table.sale { border-bottom: 1px solid black; }
table.sale thead th { border-bottom: 1px solid black; }

table div.line_description {
    text-align: left;
    font-weight: bold;
}

table div.line_note {
    text-align: left;
    padding-left: 10px;
}

table div.line_serial {
    text-align: left;
    font-weight: normal;
    padding-left: 10px;
}

table.workorders div.line_description {
    font-weight: normal;
    padding-left: 10px;
}

table.workorders div.line_note {
    font-weight: normal;
    padding-left: 10px;
}

table.workorders div.line_serial {
    font-weight: normal;
    padding-left: 20px;
}

table.workorders td.workorder div.line_note {
    font-weight: bold;
    padding-left: 0px;
}

p.thankyou {
    margin: 0;
    text-align: center;
}

.note { text-align: center; }

img.barcode {
    display: block;
    margin: 0 auto;
}

dl {
    overflow: hidden
}

dl dt {
    font-weight: bold;
    width: 80px;
    float: left
}

dl dd {
    border-top: 2px solid black;
    padding-top: 2px;
    margin: 1em 0 0;
    float: left;
    width: 180px
}

dl dd p { margin: 0; }

.strike {
  position: relative;
}
.strike:before {
  position: absolute;
  content: "";
  left: 0;
  top: 50%;
  right: 0;
  border-top: 1px solid;
}


{% endblock extrastyles %}

{% block content %}

{% set page_loaded = false %}
{% for Sale in Sales %}

{% if not parameters.page or parameters.page == 1 %}
    {% if Sale.Shop.ReceiptSetup.creditcardAgree|strlen > 0 and not parameters.gift_receipt and not parameters.email %}
        {% if parameters.force_cc_agree or parameters.print_workorder_agree %}
            {{ _self.store_receipt(Sale,parameters,SalePayment,_context) }}
            {% set page_loaded = true %}
        {% else %}
            {% for SalePayment in Sale.SalePayments.SalePayment %}
                {% if SalePayment.CreditAccount.balance > 0 and credit_account_signature == true %}
                    {{ _self.store_receipt(Sale,parameters,SalePayment,_context) }}
                    {% set page_loaded = true %}
                {% elseif SalePayment.CCCharge and SalePayment.CCCharge.isDebit == 'false' %}
                    {{ _self.store_receipt(Sale,parameters,SalePayment,_context) }}
                    {% set page_loaded = true %}
                {% endif %}
            {% endfor %}
        {% endif %}
    {% endif %}
{% endif %}

{% if not parameters.page or parameters.page == 2 or not page_loaded %}
<!-- replace.email_custom_header_msg -->
<div>
    {{ _self.ship_to(Sale) }}

    <div class="header">
        {% set logo_printed = false %}
        {% if multi_shop_logos == true %}
            {% for shop in shop_logo_array %}
                {% if shop.name == Sale.Shop.name %}
                    {% if shop.logo_url|strlen > 0 %}
                        <img src="{{ shop.logo_url }}" width ={{ logo_width }} class="logo">
                        {% set logo_printed = true %}
                    {% endif %}
                {% endif %}
            {% endfor %}
        {% elseif Sale.Shop.ReceiptSetup.hasLogo == 'true' %}
            <img src="{{ Sale.Shop.ReceiptSetup.logo }}" width={{ logo_width }} class="logo">
            {% set logo_printed = true %}
        {% endif %}
        {% if logo_printed == false %}
            <h3>{{ Sale.Shop.name }}</h3>
        {% endif %}
        {% if Sale.Shop.ReceiptSetup.header|strlen > 0 %}
            <p>{{Sale.Shop.ReceiptSetup.header|nl2br|raw}}</p>
        {% else %}
            {{ _self.address(Sale.Shop.Contact) }}
            {% for ContactPhone in Sale.Shop.Contact.Phones.ContactPhone %}
                <br />{{ContactPhone.number}}
            {% endfor %}
        {% endif %}
        </div>

    {{ _self.title(Sale,parameters,quote_to_invoice) }}
    {{ _self.date(Sale) }}
    {{ _self.sale_details(Sale,_context) }}
    {% if not parameters.gift_receipt or gift_receipt_no_lines == false %}
        {{ _self.receipt(Sale,parameters,false,_context) }}
    {% endif %}

    {# Item Count Loop #}

    {% if transaction_item_count == true %}
        {% for Line in Sale.SaleLines.SaleLine %}
            {% set transaction_item_count = transaction_item_count + Line.unitQuantity %}
        {% endfor %}
        <p>Item Count: {{ transaction_item_count - 1 }}</p>
    {% endif %}

    {# End Item count loop #}

    {% if Sale.quoteID and Sale.Quote.notes|strlen > 0 %}
        <p id="receiptQuoteNote" class="note quote">{{Sale.Quote.notes|noteformat|raw}}</p>
    {% endif %}

    {% if Sale.Shop.ReceiptSetup.generalMsg|strlen > 0 %}
        <p id="receiptNote" class="note">{{ Sale.Shop.ReceiptSetup.generalMsg|noteformat|raw }}</p>
    {% endif %}

    {% if not parameters.gift_receipt %}
        {% if hide_thank_you == false %}
           {% set hide_text = 0 %}
        {% else %}
        <p id="receiptThankYouNote" class="thankyou">
            Thank You{% if Sale.Customer %} {{Sale.Customer.firstName}} {{Sale.Customer.lastName}}{% endif %}!
            </p>
        {% endif %}

    {% endif %}

    {% if hide_barcode == false %}
        {% if hide_barcode_sku == true %}
           {% set hide_text = 1 %}
        {% else %}
           {% set hide_text = 0 %}
        {% endif %}
        <img id="barcodeImage" height="50" width="250" class="barcode" src="/barcode.php?type=receipt&number={{Sale.ticketNumber}}&hide_text={{ hide_text }}">
    {% endif %}
</div>

<!-- replace.email_custom_footer_msg -->
{% endif %}
{% endfor %}
{% endblock content %}

{% macro store_receipt(Sale,parameters,Payment,options) %}
<div class="store">
    <div class="header">
        {{ _self.title(Sale,parameters) }}
        <p class="copy">Store Copy</p>
        {{ _self.date(Sale) }}
    </div>

    {{ _self.sale_details(Sale,options) }}

    {% if options.store_copy_show_lines == true %}
        {{ _self.receipt(Sale,parameters,true,options) }}
    {% else %}
        <h2>Payments</h2>
        <table class="payments">
            {{ _self.cc_payment_info(Sale,Payment) }}
        </table>
    {% endif %}

    {% if Sale.quoteID and Sale.Quote.notes|strlen > 0 %}<p class="note quote">{{Sale.Quote.notes|noteformat|raw}}</p>{% endif %}

    {{ _self.cc_agreement(Sale,Payment,options) }}
    {{ _self.workorder_agreement(Sale) }}

    <img height="50" width="250" class="barcode" src="/barcode.php?type=receipt&number={{Sale.ticketNumber}}">

    {{ _self.ship_to(Sale) }}
</div>
{% endmacro %}

{% macro lineDescription(Line,options) %}
    {% if Line.Item %}
        <div class='line_description'>
            {% autoescape true %}{{ Line.Item.description|nl2br }}{% endautoescape %}
        </div>
    {% endif %}
    {% if Line.Note %}
        <div class='line_note'>
            {% autoescape true %}{{ Line.Note.note|noteformat|raw }}{% endautoescape %}
        </div>
    {% endif %}
    {% if Line.Serialized %}
        {% for Serialized in Line.Serialized.Serialized %}
            <div class='line_serial'>
                Serial#: {{ Serialized.serial }} {{ Serialized.color }} {{ Serialized.size }}
            </div>
        {% endfor %}
    {% endif %}
    {% if options.per_line_employee == true %}
        <div class='line_note'>
            Employee: {{ Line.Employee.firstName }}
        </div>
    {% endif %}
{% endmacro %}


{% macro title(Sale,parameters,quote_to_invoice) %}
<h1 id="receiptTypeTitle">
    {% if Sale.calcTotal >= 0 %}
        {% if Sale.completed == 'true' %}
            {% if parameters.gift_receipt %}Gift{%else%}Sales{%endif%} Receipt
        {% elseif Sale.voided == 'true' %}
            Receipt
            <large>VOIDED</large>
        {% else %}
            {% if quote_to_invoice == true %}
                Invoice
            {% else %}
                Quote
            {% endif %}
            {% if not Sale.quoteID %}
                <large>(NOT A RECEIPT)</large>
            {% endif %}
        {% endif %}
    {% else %}
        Refund Receipt
    {% endif %}
</h1>
{% endmacro %}

{% macro date(Sale) %}
<p class="date">
    {% if Sale.timeStamp %}
        {{Sale.timeStamp|correcttimezone|date('m/d/Y h:i:s A')}}
    {% else %}
        {{"now"|date('m/d/Y h:i:s A')}}
    {% endif %}
</p>
{% endmacro %}

{% macro sale_details(Sale,options) %}
<p id="receiptInfo" class="details">
    {% if Sale.quoteID > 0 %}<span id="receiptQuoteId">
        {% if options.quote_to_invoice == true %}
            Invoice #: {{Sale.quoteID}}
        {% else %}
            Quote #: {{Sale.quoteID}}
        {% endif %}</span><br />{% endif %}
    Ticket: <span id="receiptTicketId">{{Sale.ticketNumber}}</span><br />
    {% if Sale.Register %}Register: <span id="receiptRegisterName">{{Sale.Register.name}}</span><br />{% endif %}
    {% if Sale.Employee %}Employee: <span id="receiptEmployeeName">{{Sale.Employee.firstName}}</span><br />{% endif %}
    {% if Sale.Customer %}
        {% if options.company_name_override == true and Sale.Customer.company|strlen > 0 %}
            Company: <span id="receiptCompanyName"> {{Sale.Customer.company}}</span><br />
        {% elseif Sale.Customer.firstName|strlen > 0 %}
            Customer: <span id="receiptCustomerName">{{Sale.Customer.firstName}} {{Sale.Customer.lastName}}</span><br />
        {% endif %}
        {% if Sale.Customer.company|strlen > 0 and options.company_name_override == false %}
            Company: <span id="receiptCompanyName"> {{Sale.Customer.company}}</span><br />
        {% endif %}
        <span id="receiptPhonesContainer" class="indent">
        {% if options.display_full_customer_address == true %}
            {% for ContactAddress in Sale.Customer.Contact.Addresses.ContactAddress %}
                Address: {{ ContactAddress.address1 }}
                {{ ContactAddress.city }},
                {{ ContactAddress.state }},
                {{ ContactAddress.zip }}<br />
            {% endfor %}
        {% endif %}
        {% if not options.customer_name_only == true %}
            {% for Phone in Sale.Customer.Contact.Phones.ContactPhone %}
            <span data-automation="receiptPhoneNumber">{{Phone.useType}}: {{Phone.number}}</span><br />
            {% endfor %}
            {% for Email in Sale.Customer.Contact.Emails.ContactEmail %}
            Email: <span id="receiptEmail">{{Email.address}} ({{Email.useType}})</span><br />
            {% endfor %}
            </span>
        {% endif %}
        {% if options.show_customer_notes == true %}
            {% if Sale.Customer.Note.note|strlen > 0 %}
                Note: {{ Sale.Customer.Note.note|noteformat|raw }}<br />
            {% endif %}
        {% endif %}
    {% endif %}
</p>
{% endmacro %}

{% macro line(Line,parameters,options) %}
<tr>
    <th data-automation="lineItemDescription" class="description">
        {{ _self.lineDescription(Line,options) }}
        {% if options.per_line_discount == true %}
            {% if Line.calcLineDiscount > 0 and not parameters.gift_receipt %}
                <small>Discount: '{{ Line.Discount.name }}' -{{Line.calcLineDiscount|money}}</small>
            {% elseif Line.calcLineDiscount < 0 and not parameters.gift_receipt %}
                <small>Discount: '{{ Line.Discount.name }}' {{Line.calcLineDiscount|getinverse|money}}</small>
            {% endif %}
        {% endif %}
    </th>
    {% if options.show_custom_sku == true %}
        <td class="sku">{{ Line.Item.customSku }}</td>
    {% endif %}
    {% if options.show_manufacturer_sku == true %}
        <td class="sku">{{ Line.Item.manufacturerSku }}</td>
    {% endif %}
    {% if options.show_msrp == true %}
        {% set msrp_printed = false %}
        {% for price in Line.Item.Prices.ItemPrice %}
            {% if price.useType == "MSRP" and price.amount != "0"%}
                <td class="sku">{{ price.amount|money }}</td>
                {% set msrp_printed = true %}
            {% endif %}
        {% endfor %}
        {% if msrp_printed == false %}
            <td class="sku">N/A</td>
        {% endif %}
    {% endif %}
    {% if not parameters.gift_receipt %}
        {% if options.per_line_subtotal == true %}
            {% if options.per_line_discounted_subtotal == true and Line.calcLineDiscount > 0 %}
                <td data-automation="lineItemQuantity" class="quantity"><span class="strike">{{Line.unitQuantity}} x
                    {% if Line.discountAmount > 0 %}
                        {{Line.unitPrice|money}}</span><br /> {{Line.unitQuantity}} x {{ (Line.unitPrice|floatval -Line.discountAmount|floatval)|money }}</td>
                    {% elseif Line.discountPercent > 0 %}
                        {{Line.unitPrice|money}}</span><br /> {{Line.unitQuantity}} x {{ (Line.unitPrice|floatval * (1 - Line.discountPercent|floatval))|money }}</td>
                    {% endif %}
                <td data-automation="lineItemPrice" class="amount"><span class="strike">{{Line.calcSubtotal|money}}</span><br/> {{ (Line.calcSubtotal|floatval - Line.calcLineDiscount|floatval)|money }}</td>
            {% else %}
                <td data-automation="lineItemQuantity" class="quantity">{{Line.unitQuantity}} x {{Line.unitPrice|money}}</td>
                <td data-automation="lineItemPrice" class="amount">{{Line.calcSubtotal|money}}</td>
            {% endif %}
        {% elseif options.per_line_discounted_subtotal == true and Line.calcLineDiscount > 0 %}
            <td data-automation="lineItemQuantity" class="quantity">{{Line.unitQuantity}}</td>
            <td data-automation="lineItemPrice" class="amount"><span class="strike">{{Line.calcSubtotal|money}}</span><br/> {{ (Line.calcSubtotal|floatval - Line.calcLineDiscount|floatval)|money }}</td>
        {% else %}
            <td data-automation="lineItemQuantity" class="quantity">{{Line.unitQuantity}}</td>
            <td data-automation="lineItemPrice" class="amount">{{Line.calcSubtotal|money}}</td>
        {% endif %}
    {% else %}
        <td data-automation="lineItemQuantity" class="quantity">{{Line.unitQuantity}}</td>
        <td data-automation="lineItemPrice" class="amount"></td>
    {% endif %}
</tr>
{% endmacro %}

{% macro receipt(Sale,parameters,store_copy,options) %}
{% if Sale.SaleLines %}
    <table class="sale lines">
        <thead>
            <tr>
                <th class="description">Item</th>
                {% if options.show_custom_sku == true and options.show_manufacturer_sku == true %}
                    <th class="sku">Custom SKU</th>
                {% elseif options.show_custom_sku %}
                    <th class="sku">SKU</th>
                {% endif %}
                {% if options.show_custom_sku == true and options.show_manufacturer_sku == true %}
                    <th class="sku">Man. SKU </th>
                {% elseif options.show_manufacturer_sku == true %}
                    <th class="sku">SKU</th>
                {% endif %}
                {% if options.show_msrp == true %}
                    <th class="sku">MSRP</th>
                {% endif %}
                <th class="quantity">#</th>
                {% if not parameters.gift_receipt %}<th class="amount">Price</th>{% endif %}
            </tr>
        </thead>
        <tbody>
            {% for Line in Sale.SaleLines.SaleLine %}
                {{ _self.line(Line,parameters,options) }}
            {% endfor %}
        </tbody>
    </table>

    {% if not parameters.gift_receipt %}
        <table class="totals">
            <tbody id="receiptSaleTotals">
                <tr><td width="100%">Subtotal</td><td id="receiptSaleTotalsSubtotal" class="amount">{{Sale.calcSubtotal|money}}</td></tr>
                {% if Sale.calcDiscount > 0 %}
                    <tr><td>Discounts</td><td id="receiptSaleTotalsDiscounts" class="amount">-{{Sale.calcDiscount|money}}</td></tr>
                {% elseif Sale.calcDiscount < 0 %}
                    <tr><td>Discounts</td><td id="receiptSaleTotalsDiscounts" class="amount">{{Sale.calcDiscount|getinverse|money}}</td></tr>
                {% endif %}
                {% for Tax in Sale.TaxClassTotals.Tax %}
                    {% if Tax.taxname and Tax.rate > 0 %}
                        <tr><td data-automation="receiptSaleTotalsTaxName" width="100%">{{Tax.taxname}} ({{Tax.subtotal|money}} @ {{Tax.rate}}%)</td><td data-automation="receiptSaleTotalsTaxValue" class="amount">{{Tax.amount|money}}</td></tr>
                    {% endif %}
                    {% if Tax.taxname2 and Tax.rate2 > 0 %}
                        <tr><td data-automation="receiptSaleTotalsTaxName" width="100%">{{Tax.taxname2}} ({{Tax.subtotal2|money}} @ {{Tax.rate2}}%)</td><td data-automation="receiptSaleTotalsTaxValue" class="amount">{{Tax.amount2|money}}</td></tr>
                    {% endif %}
                {% endfor %}
                <tr><td width="100%">Total Tax</td><td id="receiptSaleTotalsTax" class="amount">{{Sale.taxTotal|money}}</td></tr>
                <tr class="total"><td>Total</td><td id="receiptSaleTotalsTotal" class="amount">{{Sale.calcTotal|money}}</td></tr>
            </tbody>
        </table>
    {% endif %}
{% endif %}

{% if Sale.completed == 'true' and not parameters.gift_receipt %}
    {% if Sale.SalePayments %}
        <h2>Payments</h2>
        <table id="receiptPayments" class="payments">
            <tbody>
            {% for Payment in Sale.SalePayments.SalePayment %}
                {% if Payment.PaymentType.name != 'Cash' %}
                    <!-- NOT Cash Payment -->
                    {% if Payment.CreditAccount.giftCard == 'true' %}
                        <!--  Gift Card -->
                        {% if Payment.amount > 0 %}
                            <tr>
                                <td>Gift Card Charge</td>
                                <td id="receiptPaymentsGiftCardValue" class="amount">{{Payment.amount|money}}</td>
                            </tr>
                            <tr>
                                <td>Balance</td>
                                <td id="receiptPaymentsGiftCardBalance" class="amount">{{Payment.CreditAccount.balance|getinverse|money}}</td>
                            </tr>
                        {% elseif Payment.amount < 0 and Sale.calcTotal < 0 %}
                            <tr>
                                <td>Refund To Gift Card</td>
                                <td id="receiptPaymentsGiftCardValue" class="amount">{{Payment.amount|getinverse|money}}</td>
                            </tr>
                            <tr>
                                <td>Balance</td>
                                <td id="receiptPaymentsGiftCardBalance" class="amount">{{Payment.CreditAccount.balance|getinverse|money}}
                            </tr>
                        {% elseif Payment.amount < 0 and Sale.calcTotal >= 0 %}
                            <tr>
                                <td>Gift Card Purchase</td>
                                <td id="receiptPaymentsGiftCardValue" class="amount">{{Payment.amount|getinverse|money}}</td>
                            </tr>
                            <tr>
                                <td>Balance</td>
                                <td id="receiptPaymentsGiftCardBalance" class="amount">{{Payment.CreditAccount.balance|getinverse|money}}</td>
                            </tr>
                        {% endif %}
                    {% elseif Payment.creditAccountID == 0 %}
                        <!--  NOT Customer Account -->
                        {{ _self.cc_payment_info(Sale,Payment) }}
                    {% elseif Payment.CreditAccount %}
                        <!-- Customer Account -->
                        <tr>
                            {% if Payment.amount < 0 %}
                            <td width="100%">Account Deposit</td>
                            <td class="amount">{{Payment.amount|getinverse|money}}</td>
                            {% else %}
                            <td width="100%">Account Charge</td>
                            <td class="amount">{{Payment.amount|money}}</td>
                            {% endif %}
                        </tr>
                    {% endif %}
                {% endif %}
            {% endfor %}
            <tr><td colspan="2"></td></tr>
            {{ _self.sale_cash_payment(Sale) }}
            </tbody>
        </table>
    {% endif %}

    {% if Sale.Customer and store_copy == false %}
        {% if options.hide_customer_layaways == false %}
            {{ _self.layaways(Sale.Customer,parameters.gift_receipt,options)}}
        {% endif %}
        {% if options.hide_customer_specialorders == false %}
            {{ _self.specialorders(Sale.Customer,parameters.gift_receipt,options)}}
        {% endif %}
        {% if options.hide_customer_workorders == false %}
            {{ _self.workorders(Sale.Customer,parameters.gift_receipt,options)}}
        {% endif %}
    {% endif %}

    {% if Sale.Customer and not parameters.gift_receipt and store_copy == false and options.hide_customer_credit_account == false %}
        {% if Sale.Customer.CreditAccount and Sale.Customer.CreditAccount.MetaData.creditBalanceOwed > 0 or Sale.Customer.CreditAccount.MetaData.extraDeposit > 0 %}
            <h2>Store Account</h2>
            <table class="totals">
                {% if Sale.Customer.CreditAccount.MetaData.creditBalanceOwed > 0 %}
                    <tr>
                        <td width="100%">Balance Owed: </td>
                        <td class="amount">{{ Sale.Customer.CreditAccount.MetaData.creditBalanceOwed|money }}</td>
                    </tr>
                {% elseif Sale.Customer.CreditAccount.MetaData.extraDeposit > 0 %}
                    <tr>
                        <td width="100%">On Deposit </td>
                        <td class="amount">{{ Sale.Customer.CreditAccount.MetaData.extraDeposit|money }}</td>
                    </tr>
                {% endif %}
            </table>
        {% endif %}
        {% if Sale.Customer.MetaData.getAmountToCompleteAll > 0 %}
        <table class="totals">
            <tr class="total">
                <td width="100%">Remaining Balance </td>
                <td class="amount">{{ Sale.Customer.MetaData.getAmountToCompleteAll|money }}</td>
            </tr>
        </table>
        {% endif %}
    {% endif %}

{% endif %}
{% endmacro %}

{% macro cc_payment_info(Sale,Payment) %}
<tr>
    <td width="100%">
    {{ Payment.PaymentType.name }}
        {% if Payment.ccChargeID > 0 %}
            <br>Card Num: {{Payment.CCCharge.xnum}}
            {% if Payment.CCCharge.cardType|strlen > 0 %}
                <br>Type: {%if Payment.CCCharge.isDebit %}Debit/{% endif %}{{Payment.CCCharge.cardType}}
            {% endif %}
            {% if Payment.CCCharge.cardholderName|strlen > 0 %}
                <br>Cardholder: {{Payment.CCCharge.cardholderName}}
            {% endif %}
            {% if Payment.CCCharge.entryMethod|strlen > 0 %}
                <br>Entry: {{Payment.CCCharge.entryMethod}}
            {% endif %}
            {% if Payment.CCCharge.authCode|strlen > 0 %}
                <br>Approval: {{Payment.CCCharge.authCode}}
            {% endif %}
            {% if Payment.CCCharge.gatewayTransID|strlen > 0 and Payment.CCCharge.gatewayTransID|strlen < 48 %}
                <br>ID: {{Payment.CCCharge.gatewayTransID}}
            {% endif %}
        {% endif %}
    </td>
    <td class="amount">{{Payment.amount|money}}</td>
</tr>
{% endmacro %}


{% macro cc_agreement(Sale,Payment,options) %}
{% if Payment.CCCharge or Payment.CreditAccount.balance > 0 %}
    {% if options.credit_account_agreement|strlen > 0 and Payment.CreditAccount.balance > 0 %}
        {{ options.credit_account_agreement }}
    {% elseif Sale.Shop.ReceiptSetup.creditcardAgree|strlen > 0 %}
        <p>{{Sale.Shop.ReceiptSetup.creditcardAgree|noteformat|raw}}</p>
    {% endif %}
    <dl id="signatureSection" class="signature">
        <dt>Signature:</dt>
        <dd>
            {{Payment.CCCharge.cardholderName}}<br />
        </dd>
    </dl>
{% endif %}
{% endmacro %}

{% macro workorder_agreement(Sale) %}
    {% if Sale.Shop.ReceiptSetup.workorderAgree|strlen > 0 and Sale.Workorders %}
    <!--
        @FIXME
        Should only print this work_order agreement if it's never been signed before.
        transaction->customer_id->printWorkorderAgreement($transaction->transaction_id)  -->
        <div class="signature">
            <p>{{Sale.Shop.ReceiptSetup.workorderAgree|noteformat|raw}}</p>
            <dl class="signature">
                <dt>Signature:</dt>
                <dd>{{Sale.Customer.firstName}} {{Sale.Customer.lastName}}</dd>
            </dl>
        </div>
    {% endif %}
{% endmacro %}

{% macro ship_to(Sale) %}
    {% if Sale.ShipTo %}
    <div class="shipping">
        <h4>Ship To</h4>
        {{ _self.shipping_address(Sale.ShipTo,Sale.ShipTo.Contact) }}

        {% for Phone in Sale.ShipTo.Contact.Phones.ContactPhone %}{% if loop.first %}
        <p>Phone: {{Phone.number}} ({{Phone.useType}})</p>
        {% endif %}{% endfor %}

        {% if Sale.ShipTo.shipNote|strlen > 0 %}
        <h5>Instructions</h5>
        <p>{{Sale.ShipTo.shipNote}}</p>
        {% endif %}
    </div>
    {% endif %}
{% endmacro %}

{% macro shipping_address(Customer,Contact) %}
<p>
    {% if Customer.company|strlen > 0 %}{{Customer.company}}<br>{% endif %}
    {% if Customer.company|strlen > 0 %}Attn:{% endif %} {{Customer.firstName}} {{Customer.lastName}}<br>
    {{ _self.address(Contact) }}
</p>
{% endmacro %}

{% macro address(Contact,delimiter) %}
    {% if delimiter|strlen == 0 %}{% set delimiter = '<br>' %}{% endif %}

    {% autoescape false %}
    {% for Address in Contact.Addresses.ContactAddress %}
        {% if loop.first and Address.address1 %}
            {{Address.address1}}{{delimiter}}
            {% if Address.address2|strlen > 0 %} {{Address.address2}}{{delimiter}}{% endif %}
            {{Address.city}}, {{Address.state}} {{Address.zip}} {{Address.country}}
        {% endif %}
    {% endfor %}
    {% endautoescape %}
{% endmacro %}

{% macro layaways(Customer,parameters,options) %}
    {% if Customer.Layaways and Customer.Layaways|length > 0 %}
        <h2>Layaways</h2>
        <table class="lines layaways">
            <tbody>
                {% for Line in Customer.Layaways.SaleLine %}{{ _self.line(Line,parameters,options) }}{% endfor %}
            </tbody>
        </table>
        <table class="layways totals">
            <tr>
                <td width="100%">Subtotal</td>
                <td class="amount">{{Customer.MetaData.layawaysSubtotal|money}}</td>
            </tr>
            {% if Customer.MetaData.layawaysAllDiscounts>0.00 %}
                <tr>
                    <td width="100%">Discounts</td>
                    <td class="amount">{{Customer.MetaData.layawaysAllDiscounts|money}}</td>
                </tr>
            {% endif %}
            <tr>
                <td width="100%">Tax</td>
                <td class="amount">{{Customer.MetaData.layawaysTaxTotal|money}}</td>
            </tr>
            <tr class="total">
                <td width="100%">Total</td>
                <td class="amount">{{Customer.MetaData.layawaysTotal|money}}</td>
            </tr>
        </table>
    {% endif %}
{% endmacro %}

{% macro specialorders(Customer,parameters,options) %}
    {% if Customer.SpecialOrders|length > 0 %}
        <h2>Special Orders</h2>
        <table class="lines specialorders">
            <tbody>
                {% for Line in Customer.SpecialOrders.SaleLine %}{{ _self.line(Line,parameters,options) }}{% endfor %}
            </tbody>
        </table>
        <table class="specialorders totals">
            <tr>
                <td width="100%">Subtotal</td>
                <td class="amount">{{Customer.MetaData.specialOrdersSubtotalNoDiscount|money}}</td>
            </tr>
            {% if Customer.MetaData.specialOrdersAllDiscounts > 0 %}
                <tr>
                    <td width="100%">Discounts</td>
                    <td class="amount">{{Customer.MetaData.specialOrdersAllDiscounts|money}}</td>
                </tr>
            {% endif %}
            <tr>
                <td width="100%">Tax</td>
                <td class="amount">{{Customer.MetaData.specialOrdersTaxTotal|money}}</td>
            </tr>
            <tr class="total">
                <td width="100%">Total</td>
                <td class="amount">{{Customer.MetaData.specialOrdersTotal|money}}</td>
            </tr>
        </table>
    {% endif %}
{% endmacro %}

{% macro workorders(Customer,parameters,options) %}
    {% if Customer.Workorders|length > 0 %}
        <h2>Open Workorders</h2>
        <table class="lines workorders">
            {% for Line in Customer.Workorders.SaleLine %}
                <tr>
                    {% if Line.MetaData.workorderTotal %}
                        <td class="workorder" colspan="2">{{ _self.lineDescription(Line) }}</td>
                    {% else %}
                        <td >{{ _self.lineDescription(Line) }}</td>
                        <td class="amount">{{Line.calcSubtotal|money}}</td>
                    {% endif %}
                </tr>
            {% endfor %}
        </table>
        {% if Customer.MetaData.workordersTotal > 0 %}
            <table class="workorders totals">
                <tr>
                    <td width="100%">Subtotal</td>
                    <td class="amount">{{Customer.MetaData.workordersSubtotalNoDiscount|money}}</td>
                </tr>
                {% if Customer.MetaData.specialOrdersAllDiscounts > 0 %}
                    <tr>
                        <td width="100%">Discounts</td>
                        <td class="amount">{{Customer.MetaData.workordersAllDiscounts|money}}</td>
                    </tr>
                {% endif %}
                <tr>
                    <td width="100%">Tax</td>
                    <td class="amount">{{Customer.MetaData.workordersTaxTotal|money}}</td>
                </tr>
                <tr class="total">
                    <td width="100%">Total</td>
                    <td class="amount">{{Customer.MetaData.workordersTotal|money}}</td>
                </tr>
            </table>
        {% endif %}
    {% endif %}
{% endmacro %}

{% macro sale_cash_payment(Sale) %}
    {% set total = Sale.change|floatval %}
    {% set pay_cash = 'false' %}
    {% for Payment in Sale.SalePayments.SalePayment %}
        {% if Payment.PaymentType.name == 'Cash' %}
            {% set total = total + Payment.amount|floatval %}
            {% set pay_cash = 'true' %}
            {% endif %}
    {% endfor %}
    {% if pay_cash == 'true' %}
        <tr><td width="100%">Cash</td><td id="receiptPaymentsCash" class="amount">{{total|money}}</td></tr>
        <tr><td width="100%">Change</td><td id="receiptPaymentsChange" class="amount">{{Sale.change|money}}</td></tr>
    {% endif %}
{% endmacro %}