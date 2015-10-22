{#
	***Begin Custom Options***
	Toggle any of the options in this section between 'false' and 'true' in order to enable/disable them in the template
#}

{# Layout Adjustments #}
{% set chrome_right_margin_fix = false %}           {# Fixes a potential issue where the right side of receipts are cut off in Chrome #}
{% set firefox_margin_fix = false %}                {# Fixes issue with margins cutting off when printing on a letter printer on a Mac #}

{# Item Lines #}
{% set per_line_discount = false %}                 {# Displays Discounts on each Sale Line #}
{% set per_line_subtotal = false %}                 {# Displays Subtotals for each Sale Line (ex: "1 x $5.00") #}
{% set discounted_line_items = false %}             {# Strikes out the original price and displays the discounted price on each Sale Line #}
{% set per_line_employee = false %}                 {# Display Employee for each Sale line #}
{% set show_custom_sku = false %}                   {# Adds SKU column for Custom SKU, if available, on each Sale Line #}
{% set show_manufacturer_sku = false %}             {# Adds SKU column for Manufacturer SKU, if available, on each Sale Line #}
{% set show_msrp = false %}                         {# Adds MSRP column for the items MSRP, if available, on each Sale Line #}

{# Misc. Adjustments #}
{% set show_thank_you = true %}                     {# Displays "Thank You <Customer Name>!" above bottom barcode #}
{% set show_transaction_item_count = false %}       {# Gives a total quantity of items sold near the bottom of the receipt #}
{% set show_sale_lines_on_store_copy = true %}      {# Shows Sale Lines on Credit Card Store Copy receipts #}
{% set quote_to_invoice = false %}                  {# Changes Quote wording to Invoice in Sales and in Sale Quotes (does not apply to Work Order Quotes) #}
{% set show_sale_lines_on_gift_receipt = true %}    {# Displays Sale Lines on Gift Receipts #}
{% set show_barcode = true %}                       {# Displays barcode at bottom of receipts #}
{% set show_barcode_sku = true %}                   {# Displays the System ID at the bottom of barcodes #}

{# Customer Information #}
{% set show_full_customer_address = false %}        {# Displays Customers full address, if available #}
{% set show_customer_name_only = true %}            {# Hides all Customer information except for their name #}
{% set show_customer_notes = false %}               {# Displays Notes entered in the Customers profile #}
{% set company_name_override = false %}             {# Does not display the Customer Name if Company Name is present #}

{# Customer Account #}
{% set show_credit_account_signature = false %}     {# Prints Store Copy with signature line on accounts that use an Account Credit (not Deposit) #}
{% set show_customer_layaways = true %}             {# Displays Customer Layaway information at the bottom of receipts #}
{% set show_customer_specialorders = true %}        {# Displays Customer Special Order information at the bottom of receipts #}
{% set show_customer_workorders = true %}           {# Displays Customer Work Order information at the bottom of receipts #}
{% set show_customer_credit_account = true %}       {# Displays Customer Credit Account information at the bottom of receipts #}

{# Logos #}
{% set logo_width = '225px' %}                      {# Default width is 225px. #}
{% set logo_height = '' %}                          {# Default height is 55px. #}
{% set multi_shop_logos = false %}                  {# Allows multiple logos to be added for separate locations when used with options below #}

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

@page { margin: 0px; }

body {
	font: normal 10pt 'Helvetica Neue', Helvetica, Arial, sans-serif;
	margin: 0;
	padding: 1px; <!-- You need this to make the printer behave -->
	{% if chrome_right_margin_fix == true %}
		margin-right: .13in;
	{% endif %}
	{% if firefox_margin_fix == true %}
		margin: 25px;
	{% endif %}
}

.store {
	page-break-after: always;
	margin-bottom: 40px;
}

.receipt {
	font: normal 10pt “Helvetica Neue”, Helvetica, Arial, sans-serif;
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

table td.amount, table th.amount { text-align: right; }
table td.quantity, table th.quantity { text-align: center; }

th.description {
	width: 100%;
}

td.amount { white-space: nowrap; }

table.totals { text-align: right; }
table.payments { text-align: right; }
table.spacer { margin-top: 1em; }
table tr.total td { font-weight: bold; }

table td.amount { padding-left: 10px; }
table td.custom_field {
padding-right: 10px;
text-align: center;
}

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

.strike { text-decoration: line-through; }

{% endblock extrastyles %}

{% block content %}
	{% set page_loaded = false %}
	{% for Sale in Sales %}
		{% if not parameters.page or parameters.page == 1 %}
			{% if Sale.Shop.ReceiptSetup.creditcardAgree|strlen > 0 and not parameters.gift_receipt and not parameters.email %}
				{% for SalePayment in Sale.SalePayments.SalePayment %}
					{% if parameters.force_cc_agree or parameters.print_workorder_agree %}
						{{ _self.store_receipt(Sale,parameters,_context,SalePayment) }}
						{% set page_loaded = true %}
					{% else %}
						{% if SalePayment.archived == 'false' and SalePayment.CCCharge and SalePayment.CCCharge.declined == 'false' and SalePayment.CCCharge.isDebit == 'false' %}
							{{ _self.store_receipt(Sale,parameters,_context,SalePayment) }}
							{% set page_loaded = true %}
						{% endif %}
					{% endif %}
				{% endfor %}
			{% endif %}
		{% endif %}

		{% if not parameters.page or parameters.page == 2 or not page_loaded %}
			<!-- replace.email_custom_header_msg -->
			<div>
				{{ _self.ship_to(Sale) }}

				<div class="header">
					{% set logo_printed = false %}
					{% if multi_shop_logos %}
						{% for shop in shop_logo_array if not logo_printed %}
							{% if shop.name == Sale.Shop.name %}
								{% if shop.logo_url|strlen > 0 %}
									<img src="{{ shop.logo_url }}" width ={{ logo_width }} height="{{ logo_height }}" class="logo">
									{% set logo_printed = true %}
								{% endif %}
							{% endif %}
						{% endfor %}
					{% endif %}

					{% if Sale.Shop.ReceiptSetup.logo|strlen > 0 and not logo_printed %}
						<img src="{{Sale.Shop.ReceiptSetup.logo}}" width="{{ logo_width }}" height="{{ logo_height }}" class="logo">
					{% else %}
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

				{{ _self.title(Sale,parameters,_context) }}
				{{ _self.date(Sale) }}
				{{ _self.sale_details(Sale,_context) }}
				{% if not parameters.gift_receipt or show_sale_lines_on_gift_receipt %}
					{{ _self.receipt(Sale,parameters,false,_context) }}
				{% endif %}

				{# Item Count Loop #}
				{% if show_transaction_item_count %}
					{% set transaction_item_count = 0 %}
					{% for Line in Sale.SaleLines.SaleLine %}
						{% set transaction_item_count = transaction_item_count + Line.unitQuantity %}
					{% endfor %}
					<p>Total Item Count: {{ transaction_item_count }}</p>
				{% endif %}

				{% if Sale.quoteID and Sale.Quote.notes|strlen > 0 %}<p id="receiptQuoteNote" class="note quote">{{Sale.Quote.notes|noteformat|raw}}</p>{% endif %}

				{% if Sale.Shop.ReceiptSetup.generalMsg|strlen > 0 %}<p id="receiptNote" class="note">{{ Sale.Shop.ReceiptSetup.generalMsg|noteformat|raw }}</p>{% endif %}

				{% if not parameters.gift_receipt %}
					{{ _self.no_tax_applied_text(Sale) }}
					<p id="receiptThankYouNote" class="thankyou">
						{% if show_thank_you %}
							Thank You {% if Sale.Customer %}{{Sale.Customer.firstName}} {{Sale.Customer.lastName}}{% endif %}!
						{% endif %}
					</p>
				{% endif %}

				{% if show_barcode %}
					<img id="barcodeImage" height="50" width="250" class="barcode" src="/barcode.php?type=receipt&number={{Sale.ticketNumber}}&hide_text={{ not show_barcode_sku }}">
				{% endif %}
			</div>

			<!-- replace.email_custom_footer_msg -->
		{% endif %}
	{% endfor %}
{% endblock content %}

{% macro no_tax_applied_text(Sale) %}
	{% set has_non_taxed_item = 'false' %}
	{% for Line in Sale.SaleLines.SaleLine %}
		{# If line has no tax and is not a workorder line, unless it is the workorders Labor line #}
		{% if ((Line.tax == 'false' or (Line.calcTax1 == 0 and Line.calcTax2 == 0)) and
			(Line.isWorkorder == 'false' or Line.Note.note == 'Labor')) %}
			{% set has_non_taxed_item = 'true' %}
		{% endif %}
	{% endfor %}
	{% if(has_non_taxed_item == 'true') %}
		<p class="thankyou">* {{ mostranslate('No Tax Applied') }}</p>
	{% endif %}
{% endmacro %}

{% macro store_receipt(Sale,parameters,options,Payment) %}
	<div class="store">
		<div class="header">
			{{ _self.title(Sale,parameters,options) }}
				<p class="copy">Store Copy</p>
			{{ _self.date(Sale) }}
		</div>

		{{ _self.sale_details(Sale,options) }}

		{% if options.show_sale_lines_on_store_copy %}
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
			{% autoescape true %}{{ Line.Item.description|nl2br }}{% if Line.tax == 'false' or (Line.calcTax1 == 0 and Line.calcTax2 == 0) %}*{% endif %}{% endautoescape %}
		</div>
	{% endif %}
	{% if Line.Note %}
		<div class='line_note'>
			{% autoescape true %}
				{{ Line.Note.note|noteformat|raw }}
				<!-- If line has no tax and is not a workorder line, unless it is the workorder's "Labor" line -->
				{% if (Line.tax == 'false' or (Line.calcTax1 == 0 and Line.calcTax2 == 0)) and
					(Line.isWorkorder == 'false' or Line.Note.note == 'Labor') %}
					*
				{% endif %}
			{% endautoescape %}
		</div>
	{% endif %}
	{% if Line.Serialized %}
		{% for Serialized in Line.Serialized.Serialized %}
			<div class='line_serial'>
				Serial#: {{ Serialized.serial }} {{ Serialized.color }} {{ Serialized.size }}
			</div>
		{% endfor %}
	{% endif %}
	{% if options.per_line_employee %}
		<div class='line_note'>
			Employee: {{ Line.Employee.firstName }}
		</div>
	{% endif %}
{% endmacro %}


{% macro title(Sale,parameters,options) %}
	<h1 id="receiptTypeTitle">
		{% if Sale.calcTotal >= 0 %}
			{% if Sale.completed == 'true' %}
				{% if parameters.gift_receipt %}Gift{%else%}Sales{%endif%} Receipt
			{% elseif Sale.voided == 'true' %}
				Receipt
				<large>VOIDED</large>
			{% else %}
				{% if options.quote_to_invoice %}
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
	<p class="date" id="receiptDateTime">
		{% if Sale.timeStamp %}
			{{Sale.timeStamp|correcttimezone|date(getDateTimeFormat())}}
		{% else %}
			{{"now"|date(getDateTimeFormat())}}
		{% endif %}
	</p>
{% endmacro %}

{% macro sale_details(Sale,options) %}
	<p id="receiptInfo" class="details">
		{% if Sale.quoteID > 0 %}
			{% if options.quote_to_invoice %}
				Invoice #:
			{% else %}
				Quote #:
			{% endif %}
			<span id="receiptQuoteId">{{Sale.quoteID}}</span><br />
		{% endif %}

		Ticket: <span id="receiptTicketId">{{Sale.ticketNumber}}</span><br />

		{% if isVATAndRegistrationNumberOnReceipt() %}
			VAT #: {{Sale.Shop.vatNumber}}<br />
			Company registration #: {{Sale.Shop.companyRegistrationNumber}}<br />
		{% endif %}

		{% if Sale.Register %}
			Register: <span id="receiptRegisterName">{{Sale.Register.name}}</span><br />
		{% endif %}

		{% if Sale.Employee %}
			Employee: <span id="receiptEmployeeName">{{Sale.Employee.firstName}}</span><br />
		{% endif %}

		{% if Sale.Customer %}
			{% if Sale.Customer.company|strlen > 0 %}
				Company: <span id="receiptCompanyName">{{Sale.Customer.company}}</span><br />
			{% endif %}

			{% if not options.company_name_override or not Sale.Customer.company|strlen > 0 %}
				Customer: <span id="receiptCustomerName">{{Sale.Customer.firstName}} {{Sale.Customer.lastName}}</span><br />
			{% endif %}

			{% if not options.show_customer_name_only %}
				{% set ContactAddress = Sale.Customer.Contact.Addresses.ContactAddress %}
				{% if options.show_full_customer_address and ContactAddress.address1 %}
					Address: {{ ContactAddress.address1 }}{% if ContactAddress.city %}, {{ ContactAddress.city }}{% endif %}{% if ContactAddress.state %}, {{ ContactAddress.state }}{% endif %}{% if ContactAddress.zip %}, {{ ContactAddress.zip }}{% endif %}<br />
				{% endif %}

				<span id="receiptPhonesContainer" class="indent">
					{% for Phone in Sale.Customer.Contact.Phones.ContactPhone %}
						<span data-automation="receiptPhoneNumber">{{Phone.useType}}: {{Phone.number}}</span><br />
					{% endfor %}

					{% for Email in Sale.Customer.Contact.Emails.ContactEmail %}
						Email: <span id="receiptEmail">{{Email.address}} ({{Email.useType}})</span><br />
					{% endfor %}
				</span>
			{% endif %}
			{% if options.show_customer_notes %}
				{% if Sale.Customer.Note.note|strlen > 0 %}
					Note: {{ Sale.Customer.Note.note|noteformat|raw }}<br />
				{% endif %}
			{% endif %}
		{% endif %}
	</p>
{% endmacro %}

{% macro line(isTaxInclusive,Line,parameters,options) %}
	<tr>
		<th data-automation="lineItemDescription" class="description">
			{{ _self.lineDescription(Line,options) }}
			{% if options.per_line_discount == true and not parameters.gift_receipt %}
				{% if Line.calcLineDiscount > 0 %}
					<small>Discount: '{{ Line.Discount.name }}' -{{Line.calcLineDiscount|money}}</small>
				{% elseif Line.calcLineDiscount < 0 %}
					<small>Discount: '{{ Line.Discount.name }}' {{Line.calcLineDiscount|getinverse|money}}</small>
				{% endif %}
			{% endif %}
		</th>

		{% if options.show_custom_sku and Line.Item.customSku %}
			<td class="custom_field">{{ Line.Item.customSku }}</td>
		{% endif %}
		{% if options.show_manufacturer_sku and Line.Item.manufacturerSku %}
			<td class="custom_field">{{ Line.Item.manufacturerSku }}</td>
		{% endif %}

		{% if options.show_msrp == true and not parameters.gift_receipt %}
			{% set msrp_printed = false %}
			{% for price in Line.Item.Prices.ItemPrice if not msrp_printed %}
				{% if price.useType == "MSRP" and price.amount != "0"%}
					<td class="custom_field">{{ price.amount|money }}</td>
					{% set msrp_printed = true %}
				{% endif %}
			{% endfor %}
			{% if not msrp_printed %}
				<td class="custom_field">N/A</td>
			{% endif %}
		{% endif %}

		<td data-automation="lineItemQuantity" class="quantity">
			{% if options.per_line_subtotal and options.discounted_line_items and Line.calcLineDiscount != 0 %}
				<span class="strike">{{Line.unitQuantity}} x {{Line.displayableUnitPrice|money}}</span>
			{% endif %}
			{{Line.unitQuantity}}
			{% if options.per_line_subtotal %} x
				{% if options.discounted_line_items %}
					{{ divide(Line.displayableSubtotal, Line.unitQuantity)|money }}
				{% else %}
					{{Line.displayableUnitPrice|money}}
				{% endif %}
			{% endif %}
		</td>

		<td data-automation="lineItemPrice" class="amount">
			{% if not parameters.gift_receipt %}
				{% if options.discounted_line_items and not options.per_line_subtotal and Line.calcLineDiscount != 0 %}
					{% if not isTaxInclusive or isTaxInclusive == 'false' %}
						<span class="strike">{{ Line.calcSubtotal|money }}</span><br />
					{% else %}
						<span class="strike">{{ multiply(Line.displayableUnitPrice, Line.unitQuantity)|money }}</span><br />
					{% endif %}
				{% endif %}
				{{ Line.displayableSubtotal|money }}
			{% endif %}
		</td>
	</tr>
{% endmacro %}

{% macro receipt(Sale,parameters,store_copy,options) %}
	{% if Sale.SaleLines %}
		<table class="sale lines">
			<thead>
				<tr>
					<th class="description">Item</th>

					{% if options.show_custom_sku and options.show_manufacturer_sku %}
						<th class="custom_field">Custom SKU</th>
						<th class="custom_field">Man. SKU </th>
					{% elseif options.show_custom_sku or options.show_manufacturer_sku %}
						<th class="custom_field">SKU</th>
					{% endif %}

					{% if options.show_msrp and not parameters.gift_receipt %}
						<th class="custom_field">MSRP</th>
					{% endif %}

					<th class="quantity">#</th>

					{% if not parameters.gift_receipt %}
						<th class="amount">Price</th>
					{% endif %}
				</tr>
			</thead>
			<tbody>
				{% for Line in Sale.SaleLines.SaleLine %}
					{{ _self.line(Sale.isTaxInclusive,Line,parameters,options) }}
				{% endfor %}
			</tbody>
		</table>

		{% if not parameters.gift_receipt %}
			<table class="totals">
				<tbody id="receiptSaleTotals">
					<tr>
						<td width="100%">
							{% if options.discounted_line_items and Sale.calcDiscount != 0 %}
								Subtotal w/ Discounts
							{% else %}
								Subtotal
							{% endif %}
						</td>
						<td id="receiptSaleTotalsSubtotal" class="amount">
							{% if options.discounted_line_items %}
								{{ subtract(Sale.displayableSubtotal, Sale.calcDiscount)|money}}
							{% else %}
								{{Sale.displayableSubtotal|money}}
							{% endif %}
						</td>
					</tr>
					{% if not options.discounted_line_items and Sale.calcDiscount > 0 %}
						<tr><td>Discounts</td><td id="receiptSaleTotalsDiscounts" class="amount">-{{Sale.calcDiscount|money}}</td></tr>
					{% elseif not options.discounted_line_items and Sale.calcDiscount < 0 %}
						<tr><td>Discounts</td><td id="receiptSaleTotalsDiscounts" class="amount">{{Sale.calcDiscount|getinverse|money}}</td></tr>
					{% endif %}
					{% for Tax in Sale.TaxClassTotals.Tax %}
						{% if Tax.taxname and Tax.rate > 0 %}
							<tr><td data-automation="receiptSaleTotalsTaxName" width="100%">{{Tax.taxname}} ({{Sale.calcTaxable|money}} @ {{Tax.rate}}%)</td><td data-automation="receiptSaleTotalsTaxValue" class="amount">{{Tax.amount|money}}</td></tr>
						{% endif %}
						{% if Tax.taxname2 and Tax.rate2 > 0 %}
							<tr><td data-automation="receiptSaleTotalsTaxName" width="100%">{{Tax.taxname2}} ({{Sale.calcTaxable|money}} @ {{Tax.rate2}}%)</td><td data-automation="receiptSaleTotalsTaxValue" class="amount">{{Tax.amount2|money}}</td></tr>
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
									<td>Account Deposit</td>
									<td id="receiptPaymentsCreditAccountDepositValue" class="amount">{{Payment.amount|getinverse|money}}</td>
									{% else %}
									<td>Account Charge</td>
									<td id="receiptPaymentsCreditAccountChargeValue" class="amount">{{Payment.amount|money}}</td>
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

		{% if Sale.Customer and not store_copy %}
			{% if options.show_customer_layaways %}
				{{ _self.layaways(Sale.Customer,Sale.isTaxInclusive,parameters.gift_receipt,options)}}
			{% endif %}
			{% if options.show_customer_specialorders %}
				{{ _self.specialorders(Sale.Customer,Sale.isTaxInclusive,parameters.gift_receipt,options)}}
			{% endif %}
			{% if options.show_customer_workorders %}
				{{ _self.workorders(Sale.Customer,parameters.gift_receipt,options)}}
			{% endif %}
		{% endif %}

		{% if options.show_customer_credit_account and Sale.Customer and not parameters.gift_receipt and not store_copy %}
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
		{% if Payment.archived == 'false' %}
			{% if Payment.ccChargeID > 0 and Payment.CCCharge.declined == 'false' %}
				<td width="100%">
					{{ Payment.PaymentType.name }}
					<br>Card Num: {{Payment.CCCharge.xnum}}
					{% if Payment.CCCharge.cardType|strlen > 0 %}
						<br>Type: {{Payment.CCCharge.cardType}}
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
					{% if Payment.CCCharge.MetaData.isEMV %}
						{% if Payment.CCCharge.MetaData.AID|strlen > 0 %}
							<br>AID: {{Payment.CCCharge.MetaData.AID}}
						{% endif %}
						{% if Payment.CCCharge.MetaData.ApplicationLabel|strlen > 0 %}
							<br>Application Label: {{Payment.CCCharge.MetaData.ApplicationLabel}}
						{% endif %}
						{% if Payment.CCCharge.exp|strlen > 0 and
							Payment.CCCharge.cardType|upper != 'MASTERCARD' and
							Payment.CCCharge.cardType|upper != 'VISA' %}
							<br>Card Expires: {{Payment.CCCharge.exp}}
						{% endif %}
						{% if Payment.CCCharge.MetaData.PINStatement|strlen > 0 %}
							<br>PIN Statement: {{Payment.CCCharge.MetaData.PINStatement}}
						{% endif %}
					{% endif %}
				</td>
				<td class="amount">{{Payment.amount|money}}</td>
			{% elseif Payment.ccChargeID == 0 %}
				<td width="100%">
					{{ Payment.PaymentType.name }}
				</td>
				<td class="amount">{{Payment.amount|money}}</td>
			{% endif %}
		{% endif %}
	</tr>
{% endmacro %}


{% macro cc_agreement(Sale,Payment,options) %}
	{% if Payment.CCCharge %}
		{% if Sale.Shop.ReceiptSetup.creditcardAgree|strlen > 0 %}
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

{% macro layaways(Customer,isTaxInclusive,parameters,options) %}
	{% if Customer.Layaways and Customer.Layaways|length > 0 %}
		<h2>{{ mostranslate('layaway', 'plural', true, 'capitalize', true) }}</h2>
		<table class="lines layaways">
			<tbody>
			{% for Line in Customer.Layaways.SaleLine %}
				{{ _self.line(isTaxInclusive,Line,parameters,options)}}
			{% endfor %}
			</tbody>
		</table>
		<table class="layways totals">
			<tr>
				<td width="100%">Subtotal</td>
				<td class="amount">{{Customer.MetaData.layawaysSubtotalNoDiscount|money}}</td>
			</tr>
			{% if Sale.Customer.MetaData.layawaysAllDiscounts>0.00 %}
				<tr>
					<td width="100%">Discounts</td>
					<td class="amount">{{Customer.MetaData.layawaysAllDiscounts|money}}</td>
				</tr>
			{% endif %}
			<tr>
				<td width="100%">Total Tax</td>
				<td class="amount">{{Customer.MetaData.layawaysTaxTotal|money}}</td>
			</tr>
			<tr class="total">
				<td width="100%">Total</td>
				<td class="amount">{{Customer.MetaData.layawaysTotal|money}}</td>
			</tr>
		</table>
	{% endif %}
{% endmacro %}

{% macro specialorders(Customer,isTaxInclusive,parameters,options) %}
	{% if Customer.SpecialOrders|length > 0 %}
		<h2>Special Orders</h2>
		<table class="lines specialorders">
			<tbody>
				{% for Line in Customer.SpecialOrders.SaleLine %}
					{{ _self.line(isTaxInclusive,Line,parameters,options) }}
				{% endfor %}
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
				<td width="100%">Total Tax</td>
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
						<td class="workorder" colspan="2">{{ _self.lineDescription(Line,options) }}</td>
					{% else %}
						<td>{{ _self.lineDescription(Line,options) }}</td>
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
					<td width="100%">Total Tax</td>
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