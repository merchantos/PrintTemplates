{% extends parameters.print ? "printbase" : "base" %}
{% block extrastyles %}
body {
  margin: 0;
  padding: 0;
}
@page {	margin: 0: }
.store { page-break-after: always; }
.receipt {
	font: normal 10pt 'Helvetica Neue',Helvetica,Arial,sans-serif;
}
.receipt .header h3, .receipt .header p {
	font-size: 10pt;
	margin: 0;
}
.receipt h2 {
	border-bottom: 1px solid black;
	text-transform: uppercase;
	font-size: 10pt;
	margin: .5em 0 0;
}
.receipt .header {
	text-align: center;
}
.receipt .header img { 
	display: block;
	margin: 8px auto 4px; 
}
.receipt h1 {
	margin: .5em 0 0;
	font-size: 12pt;
	text-align: center;
}
.receipt p.date, .receipt p.copy {
	font-size: 9pt;
	margin: 0;
}

.receipt table {
	margin: 0 0;
	width: 100%;
	border-collapse:collapse;
}


.receipt table thead th { text-align: left; }
.receipt table tbody th { 
	font-weight: normal; 
	text-align: left; 
}
.receipt table td.amount, .receipt table th.amount {
  width: 30%;
  text-align: right;
}

.receipt table.totals { text-align: right; }
.receipt table.payments { text-align: right; }
.receipt table.spacer { margin-top: 1em; }
.receipt table tr.total td { font-weight: bold; }

.receipt table.sale { border-bottom: 1px solid black; }
.receipt table.sale thead th { border-bottom: 1px solid black; }
.receipt table.sale tbody th { font-weight: bold; }

.receipt p.thankyou { 
	margin: 0; 
	text-align: center;
}
.receipt img.barcode {
	display: block;
	margin: 0 auto; 
}

.receipt dl {
	overflow: hidden
}
.receipt dl dt { 
	font-weight: bold;
	width: 80px;
	float: left
}
.receipt dl dd {
	border-top: 2px solid black;
	padding-top: 2px;
	margin: 1em 0 0;
	float: left;
	width: 180px
}
.receipt dl dd p { margin: 0; }



{% endblock extrastyles %}
{% block content %}
{% for Sale in Sales %}

{% for Payment in Sale.SalePayments.SalePayment %}
	{% if Payment.CCCharge %}
		{% set has_cc_charge = true %}
	{% endif %}
{% endfor %}

{% if Sale.Shop.ReceiptSetup.creditcardAgree|strlen > 0 and not parameters.gift_receipt and not parameters.email %}
	{% if has_cc_charge or parameters.force_cc_agree or parameters.print_workorder_aggree %}
<div class="receipt store">
	<div class="header">
		{{ _self.title(Sale,parameters) }}
		<p class="copy">Store Copy</p>
		{{ _self.date(Sale) }}
	</div>
	
	{{ _self.sale_details(Sale) }}
	{{ _self.receipt(Sale,parameters) }}

	{% if Sale.quoteID and Sale.Quote.notes|strlen > 0 %}<p class="note quote">{{Sale.Quote.notes|nl2br}}</p>{% endif %}

	{{ _self.cc_agreement(Sale) }}
	{{ _self.workorder_agreement(Sale) }}

	<img height="50" width="250" class="barcode" src="/barcode.php?type=receipt&number={{Sale.ticketNumber}}">	

	{{ _self.ship_to(Sale) }}
</div>
	{% endif %}
{% endif %}

<!-- replace.email_custom_header_msg -->
<div class="receipt customer">
	{{ _self.ship_to(Sale) }}

	<div class="header">		
		{% if Sale.Shop.ReceiptSetup.logo|strlen > 0  %}
		<img src="/{{Sale.Shop.ReceiptSetup.logo}}" width="{{Sale.Shop.ReceiptSetup.logoWidth}}" height="{{Sale.Shop.ReceiptSetup.logoHeight}}" class="logo">
		{% endif %}
		<h3>{{ Sale.Shop.name }}</h3>
	{% if Sale.Shop.ReceiptSetup.header|strlen > 0 %}
		{{Sale.Shop.ReceiptSetup.header}}
	{% else %}
		<p>{{ _self.address(Sale.Shop.Contact) }}</p>
		{% for ContactPhone in Sale.Shop.Contact.Phones.ContactPhone %}{% if loop.first %}
		<p>{{ContactPhone.number}}</p>
		{% endif %}{% endfor %}
	{% endif %}
	</div>

	{{ _self.title(Sale,parameters) }}
	{{ _self.date(Sale) }}
	{{ _self.sale_details(Sale) }}
	{{ _self.receipt(Sale,parameters) }}

	{% if Sale.quoteID and Sale.Quote.notes|strlen > 0 %}<p class="note quote">{{Sale.Quote.notes|nl2br}}</p>{% endif %}

	{% if Sale.Shop.ReceiptSetup.generalMsg|strlen > 0 %}<p class="note">{{ Sale.Shop.ReceiptSetup.generalMsg|nl2br }}</p>{% endif %}

	{% if not parameters.gift_receipt %}
	<p class="thankyou">Thank You {% if Sale.Customer %}{{Sale.Customer.firstName}} {{Sale.Customer.lastName}}{% endif %}!</p>
	{% endif %}

	<img height="50" width="250" class="barcode" src="/barcode.php?type=receipt&number={{Sale.ticketNumber}}">
</div>

<!-- replace.email_custom_footer_msg -->
{% endfor %}
{% endblock content %}

{% macro title(Sale,parameters) %}
<h1>
	{% if not Sale.parentSaleID > 0 and Sale.calcTotal >= 0 %}
		{% if Sale.completed == 'true' %}
			{% if parameters.gift_receipt %}Gift{%else%}Sales{%endif%} Receipt
		{% elseif Sale.voided == 'true' %}
			Receipt 
			<large>VOIDED</large>
		{% else %}
			Quote
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
		{{Sale.timeStamp|date('m/d/Y h:i:s A')}}
	{% else %}
		{{"now"|date('m/d/Y h:i:s A')}}
	{% endif %}
</p>
{% endmacro %}

{% macro sale_details(Sale) %}
<p>
	{% if Sale.quoteID %}Quote #: {{Sale.quoteID}}{% endif %}<br />
	Ticket: {{Sale.ticketNumber}}<br />
	{% if Sale.Register %}Register: {{Sale.Register.name}}<br />{% endif %}
	{% if Sale.Employee %}Employee: {{Sale.Employee.firstName}} {{Sale.Employee.lastName}}<br />{% endif %}
	{% if Sale.Customer %}
		{% if Sale.Customer.company%}Company: {{Sale.Customer.company}}<br />{% endif %}
		Customer: {{Sale.Customer.firstName}} {{Sale.Customer.lastName}}<br />
	{% endif %}
</p>
{% endmacro %}

{% macro line(Line,parameters) %}
<tr>
	<th>{{Line.Item.description|nl2br}}</th>
	<td class="quantity">{{Line.unitQuantity}}</td>
	<td class="amount">{% if not parameters.gift_receipt %}{{Line.calcSubtotal|money}}{% endif %}</td>
</tr>
{% endmacro %}

{% macro receipt(Sale,parameters) %}
{% if Sale.SaleLines %}
<table class="sale lines">
	<thead>
		<tr>
			<th>Item</th>
			<th></th>
			<th class="amount">Price</th>
		</tr>
	</thead>
	<tbody>
		{% for Line in Sale.SaleLines.SaleLine %}
			{{ _self.line(Line,parameters) }}
		{% endfor %}
	</tbody>
</table>

{% if not parameters.gift_receipt %}
<table class="totals">
	<tbody>
  		<tr><td>Subtotal</td><td class="amount">{{Sale.calcSubtotal|money}}</td></tr>
  		{% if Sale.calcDiscount > 0 %}<tr><td>Discounts</td><td class="amount">{{Sale.calcDiscount|money}}</td></tr>{% endif %}
		{% for Tax in Sale.TaxClassTotals.Tax %}
		<tr><td>{{Tax.name}} Tax ({{Tax.taxable|money}} @ {{Tax.rate}}%)</td><td class="amount">{{Tax.amount|money}}</td></tr>
		{% endfor %}
		<tr><td>Total Tax</td><td class="amount">{{Sale.calcTax1|money}}</td></tr>
		<tr class="total"><td>Total</td><td class="amount">{{Sale.calcTotal|money}}</td></tr>
	</tbody>
</table>
{% endif %}
{% endif %}

{% if Sale.completed == 'true' and not parameters.gift_receipt %}
	{% if Sale.SalePayments %}
		<h2>Payments</h2>
		<table class="payments">
			{% for Payment in Sale.SalePayments.SalePayment %}
				{% if Payment.isCurrentCash != 'true' %}
					<!-- NOT Cash Payment -->
					{% if Payment.CreditAccount.giftCard == 'true' %}
						<!--  Gift Card -->
						{% if Payment.amount > 0 %}
						<tr >
							<td>
								Gift Card Charge<br />
								New Balance: <!-- Card balance here --> 
							</td>
							<td>{{Payment.amount|money}}</td>
						</tr>
						{% elseif Payment.amount < 0 and Sale.calcTotal <= 0 %}
						<tr><td>Refund To Gift Card</td><td>{{Payment.amount|money}}</td></tr>
						{% elseif Payment.amount < 0 and Sale.calcTotal > 0 %}
						<tr><td>Gift Card Purchase</td><td>{{Payment.amount|money}}</td></tr>
						{% endif %}
					{% elseif Payment.creditAccountID == 0 %}
						<!--  NOT Customer Account -->
						<tr>
							<td>
								{{ Payment.PaymentType.name }}
	
								{% if Payment.ccChargeID > 0 %}
									{% if Payment.CCCharge %}
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
										{% if Payment.CCCharge.gatewayTransID|strlen > 0 %}
											<br>ID: {{Payment.CCCharge.gatewayTransID}}
										{% endif %}
									{% endif %}
								{% endif %}
							</td>
							<td>{{Payment.amount|money}}</td>
						</tr>
					{% elseif Payment.creditAccountID == Sale.Customer.creditAccountID %}
						<!-- Customer Account -->
						<tr>
							<td>
								{% if Payment.amount < 0 %}Account Deposit
								{% else %}Account Charge
								{% endif %}
							</td>
							<td>{{Payment.amount|money}}</td>
						</tr>
					{% endif %}
				{% endif %}
			{% endfor %}
			<tr><td colspan="2"></td></tr>
			{% if Sale.MetaData.currentCashPayments != 0 %}
				<tr><td>Cash</td><td>{{Sale.MetaData.currentCashPayments|money}}</td></tr>
				<tr><td>Change</td><td>{{Sale.change|money}}</td></tr>
			{% endif %}
		</table>
	{% endif %}
	
	{% if Sale.Customer %}
		{{ _self.layaways(Sale.Customer,parameters.gift_receipt)}}
		{{ _self.specialorders(Sale.Customer,parameters.gift_receipt)}}
		{{ _self.workorders(Sale.Customer,parameters.gift_receipt)}}
	{% endif %}
	
	{% if Sale.Customer and not parameters.gift_receipt %}
		{% if Sale.Customer.CreditAccount and Sale.Customer.CreditAccount.MetaData.creditBalanceOwed > 0 or Sale.Customer.CreditAccount.MetaData.extraDeposit > 0 %}
			<h2>Store Account</h2>
			<table class="totals">
				{% if Sale.Customer.CreditAccount.MetaData.creditBalanceOwed > 0 %}
				<tr>
					<td>Balance Owed</td>
					<td class="amount">{{ Sale.Customer.CreditAccount.MetaData.creditBalanceOwed|money }}</td>
				</tr>
				{% elseif Sale.Customer.CreditAccount.MetaData.extraDeposit > 0 %}
				<tr>
					<td>On Deposit</td>
					<td class="amount">{{ Sale.Customer.CreditAccount.MetaData.extraDeposit|money }}</td>
				</tr>
				{% endif %}
			</table>
		{% endif %}
		{% if Sale.Customer.MetaData.total > 0 %}
			<table class="spacer totals">
			<tr class="total">
				<td>Remaining Balance: </td>
				<td class="amount">-{{ Sale.Customer.MetaData.total|money }}</td>
			</tr>
			</table>
		{% endif %}
	</table>
	{% endif %}

{% endif %}
{% endmacro %}

{% macro cc_agreement(Sale) %}
	{% if Sale.Shop.ReceiptSetup.creditcardAgree|strlen > 0 %}
	<p>{{Sale.Shop.ReceiptSetup.creditcardAgree|nl2br}}</p>
	{% endif %}
	<dl class="signature">
		<dt>Signature:</dt>
		<dd>
			{{Sale.Customer.firstName}} {{Sale.Customer.lastName}} ({{Sale.Customer.customerID}})<br />
			{% for Phone in Sale.Customer.Contact.Phones.ContactPhone %}
			{{Phone.useType}}: {{Phone.number}}<br />
			{% endfor %}
			{{ _self.address(Sale.Customer.Contact) }}
		</dd>
	</dl>
{% endmacro %}

{% macro workorder_agreement(Sale) %}
	{% if Sale.Shop.ReceiptSetup.workorderAgree|strlen > 0 %}
	<!-- 
		@FIXME
		Should only print this work_order agreement if it's never been signed before.
		transaction->customer_id->printWorkorderAgreement($transaction->transaction_id)  -->
	
<div class="signature">
	<p>{{Sale.Shop.ReceiptSetup.workorderAgree|nl2br}}</p>
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
		{{ _self.shipping_address(Sale.Customer,Sale.ShipTo.Contact) }}
		
		{% for Phone in Sale.ShipTo.Contact.Phones.ContactPhone %}{% if loop.first %}
		<p>Phone: {{Phone.number}} ({{Phone.useType}})</p>
		{% endif %}{% endfor %}
		
		{% if Sale.ShipTo.shipNote|strlen == 0 %}
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

{% macro layaways(Customer,parameters) %}
	{% if Customer.Layaways and Customer.Layaways|length > 0 %}
	<h2>Layaways</h2>
	<table class="lines layaways">
		{% for Line in Customer.Layaways.SaleLine %}{{ _self.line(Line,parameters)}}{% endfor %}
	</table>
	<table class="layways totals">
		<tr>
			<td>Subtotal</td>
			<td class="amount">{{Customer.MetaData.layawaysSubtotalNoDiscount|money}}</td>
		</tr>
		{% if Customer.MetaData.layawaysAllDiscounts>0.00 %}
		<tr>
			<td>Discounts</td>
			<td class="amount">{{Customer.MetaData.layawaysAllDiscounts|money}}</td>
		</tr>
		{% endif %}
		<tr>
			<td>Tax</td>
			<td class="amount">{{Customer.MetaData.layawaysTaxTotal|money}}</td>
		</tr>
		<tr class="total">
			<td>Total</td>
			<td class="amount">{{Customer.MetaData.layawaysTotal|money}}</td>
		</tr>
	</table>
	{% endif %}
{% endmacro %}

{% macro specialorders(Customer,parameters) %}
	{% if Customer.SpecialOrders|length > 0 %}
	<h2>Special Orders</h2>
	<table class="lines specialorders">
		{% for Line in Customer.SpecialOrders.SaleLine %}{{ _self.line(Line,parameters) }}{% endfor %}
	</table>
	<table class="specialorders totals">
		<tr>
			<td>Subtotal</td>
			<td class="amount">{{Customer.MetaData.specialOrdersSubtotalNoDiscount|money}}</td>
		</tr>
		{% if Customer.MetaData.specialOrdersAllDiscounts > 0 %}
			<tr>
				<td>Discounts</td>
				<td class="amount">{{Customer.MetaData.specialOrdersAllDiscounts|money}}</td>
			</tr>
		{% endif %}
		<tr>
			<td>Tax</td>
			<td class="amount">{{Customer.MetaData.specialOrdersTaxTotal|money}}</td>
		</tr>
		<tr class="total">
			<td>Total</td>
			<td class="amount">{{Customer.MetaData.specialOrdersTotal|money}}</td>
		</tr>
	</table>
	{% endif %}
{% endmacro %}

{% macro workorders(Customer,parameters) %}
	{% if Customer.Workorders|length > 0 %}
		<h2>Open Workorders</h2>
		<table class="lines workorders">
			{% for Line in Customer.Workorders.SaleLine %}
				<tr>
					{% autoescape false %}<th>{{Line.Note.note|nl2br}}</th>{% endautoescape %}
				</tr>
			{% endfor %}
		</table>
		{% if Customer.Workorders|length > 1 %}
			<table class="workorders totals">
				<tr>
					<td>Total</td>
					<td>{{Customer.MetaData.workordersTotal|money}}</td>
				</tr>
			</table>
		{% endif %}
	{% endif %}
{% endmacro %}
