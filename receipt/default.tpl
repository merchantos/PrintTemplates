{% extends parameters.print ? "printbase" : "base" %}
{% block extrastyles %}
.store { background-color: #ffc; }
{% endblock extrastyles %}
{% block content %}
{% for Sale in Sales %}

{% for Payment in Sale.SalePayments.SalePayment %}
	{% if Payment.CCCharge %}
		{% set has_cc_charge = true %}
	{% endif %}
{% endfor %}

{% if Sale.Shop.ReceiptSetup.creditcardAgree|length > 0 and not parameters.gift_receipt %}
	{% if has_cc_charge or parameter.force_cc_agree or parameter.print_workorder_aggree %}
<div class="receipt store">
	{{ _self.title(Sale,parameters) }}
	<p>Store Copy</p>
	{{ _self.date(Sale) }}

	{{ _self.sale_details(Sale) }}
	{{ _self.receipt(Sale,parameters) }}

	{% if Sale.quoteID and Sale.Quote.notes|length > 0 %}<p class="note quote">{{Sale.Quote.notes|nl2br}}</p>{% endif %}

	{{ _self.cc_agreement(Sale) }}
	{{ _self.workorder_agreement(Sale) }}

	<img height="50" width="250" class="barcode" src="/barcode.php?type=receipt&number={{Sale.ticketNumber}}">	

	{{ _self.ship_to(Sale) }}
</div>
	{% endif %}
{% endif %}

<div class="receipt customer">
	{{ _self.ship_to(Sale) }}

	{% if Sale.Shop.ReceiptSetup.logo|length > 1  %}
	<img src="{{Sale.Shop.ReceiptSetup.logo}}" width="{{Sale.Shop.ReceiptSetup.logoWidth}}" height="{{Sale.Shop.ReceiptSetup.logoHeight}}" class="logo">
	{% endif %}

	<div class="header">
	{% if Sale.Shop.ReceiptSetup.header|length > 1 %}
		{{Sale.Shop.ReceiptSetup.header}}
	{% else %}
		<h3>{{ Sale.Shop.name }}</h3>
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

	{% if Sale.Shop.ReceiptSetup.generalMsg|length > 0 %}<p class="note">{{ Sale.Shop.ReceiptSetup.generalMsg|nl2br }}</p>{% endif %}
	{% if Sale.quoteID and Sale.Quote.notes|length > 0 %}<p class="note quote">{{Sale.Quote.notes|nl2br}}</p>{% endif %}

	{% if not parameters.gift_receipt %}
	<p>Thank You {% if Sale.Customer %}{{Sale.Customer.firstName}} {{Sale.Customer.lastName}}{% endif %}!</p>
	{% endif %}

	<img height="50" width="250" class="barcode" src="/barcode.php?type=receipt&number={{Sale.ticketNumber}}">
</div>
{% endfor %}
{% endblock content %}

{% macro title(Sale,parameters) %}
<h1>
	{% if not Sale.parentSaleID > 0 and Sale.calcTotal >= 0 %}
		{% if Sale.completed == 1 %}
			{% if parameters.gift_receipt %}Gift{%else%}Sales{%endif%} Receipt
		{% elseif Sale.voided == 1 %}
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
		Customer: {{Sale.Customer.firstName}} {{Sale.Customer.lastName}} ({{Sale.Customer.customerID}})<br />
		<span class="indent">
		{% for Phone in Sale.Customer.Contact.Phones.ContactPhone %}
		{{Phone.useType}}: {{Phone.number}}<br />
		{% endfor %}
		{% for Email in Sale.Customer.Contact.Emails.ContactEmail %}
		Email: {{Email.address}} ({{Email.useType}})<br />
		{% endfor %}
		</span>
	{% endif %}
</p>
{% endmacro %}

{% macro line(Line,parameters) %}
<tr>
	<th>{{Line.Item.description|nl2br}}</th>
	<td>{{Line.unitQuantity}}</td>
	<td>{% if not parameters.gift_receipt %}{{Line.calcTotal|money}}{% endif %}</td>
</tr>
{% endmacro %}

{% macro receipt(Sale,parameters) %}
<table class="lines">
	<thead>
		<tr>
			<th>Item</th>
			<th></th>
			<th>Price</th>
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
  		<tr><td>Subtotal</td><td>{{Sale.calcSubtotal|money}}</td></tr>
  		{% if Sale.calcDiscount > 0 %}<tr><td>Discounts</td><td>{{Sale.calcDiscount|money}}</td></tr>{% endif %}
		{% for Tax in Sale.TaxClassTotals.Tax %}
		<tr><td>{{Tax.name}} Tax ({{Tax.taxable|money}} @ {{Tax.rate}}%)</td><td>{{Tax.amount|money}}</td></tr>
		{% endfor %}
		<tr><td>Total Tax</td><td>{{Sale.calcTax1|money}}</td></tr>
		<tr><td>Total</td><td>{{Sale.calcTotal|money}}</td></tr>
	</tbody>
</table>
{% endif %}

{% if Sale.completed == 1 and not parameters.gift_receipt %}
	{% if Sale.SalePayments %}
	<table class="payments">
		<tr><th colspan="2">Payments</th></tr>
		{% for Payment in Sale.SalePayments.SalePayment %}
			<!-- NOT Cash Payment -->
			{% if not Payment.isCurrentCash == 1 %}
				<!--  Gift Card -->
				{% if Payment.CreditAccount.giftCard == 1 %}
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
					<tr>
						<td>
							{{ Payment.PaymentType.name }}

							{% if Payment.ccChargeID > 0 %}
								{% if Payment.CCCharge %}
									<br>Card Num: {{Payment.CCCharge.xnum}}
									{% if Payment.CCCharge.cardType|length > 0 %}
										<br>Type: {%if Payment.CCCharge.isDebit %}Debit/{% endif %}{{Payment.CCCharge.cardType}}
									{% endif %}
									{% if Payment.CCCharge.cardholderName|length > 0 %}
										<br>Cardholder: {{Payment.CCCharge.cardholderName}}
									{% endif %}
									{% if Payment.CCCharge.entryMethod|length > 0 %}
										<br>Entry: {{Payment.CCCharge.entryMethod}}
									{% endif %}
									{% if Payment.CCCharge.authCode|length > 0 %}
										<br>Approval: {{Payment.CCCharge.authCode}}
									{% endif %}
									{% if Payment.CCCharge.gatewayTransID|length > 0 %}
										<br>ID: {{Payment.CCCharge.gatewayTransID}}
									{% endif %}
								{% endif %}
							{% endif %}
						</td>
						<td>{{Payment.amount|money}}</td>
					</tr>
				<!-- Customer Account -->
				{% elseif Payment.creditAccountID == Sale.Customer.creditAccountID %}
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
		{% if Sale.MetaData.getCurrentCashPayments != 0 %}
		<tr><td>Cash</td><td>{{Sale.MetaData.getCurrentCashPayments|money}}</td></tr>
		<tr><td>Change</td><td>{{Sale.change|money}}</td></tr>
		{% endif %}
	</table>
	{% endif %}

	{% if Sale.Customer and not parameters.gift_receipt %}
	<table>
		{% if Sale.Customer.CreditAccount and Sale.Customer.CreditAccount.MetaData.creditBalanceOwed > 0 or Sale.Customer.MetaData.extraDeposit > 0 %}
		<tr><th colspan="2">Store Account</th></tr>
			{% if Sale.Customer.CreditAccount.MetaData.creditBalanceOwed > 0 %}
			<tr>
				<td>Balance Owed</td>
				<td>{{ Sale.Customer.CreditAccount.MetaData.creditBalanceOwed|money }}</td>
			</tr>
			{% elseif Sale.Customer.CreditAccount.MetaData.extraDeposit > 0 %}
			<tr>
				<td>On Deposit</td>
				<td>{{ Sale.CreditAccount.MetaData.extraDeposit|money }}</td>
			</tr>
			{% endif %}
		{% endif %}
		{% if Sale.Customer.MetaData.getAmountToCompleteAll > 0 %}
		<tr>
			<td>Needed to complete all open orders:</td>
			<td>{{ Sale.Customer.MetaData.getAmountToCompleteAll|money }}</td>
		</tr>
		{% endif %}
	</table>
	{% endif %}
	
	{% if Sale.Customer %}
		{{ _self.layaways(Sale.Customer,parameters.gift_receipt)}}
		{{ _self.specialorders(Sale.Customer,parameters.gift_receipt)}}
		{{ _self.workorders(Sale.Customer,parameters.gift_receipt)}}
	{% endif %}
{% endif %}
{% endmacro %}

{% macro cc_agreement(Sale) %}
	{% if Sale.Shop.ReceiptSetup.creditcardAgree|length > 0 %}
	<p>{{Sale.Shop.ReceiptSetup.creditcardAgree|nl2br}}</p>
	{% endif %}
	<dl>
		<dt>Signature</dt>
		<dd>
			<div class="signature_line"></div><br />
			{{Sale.Customer.firstName}} {{Sale.Customer.lastName}} ({{Sale.Customer.customerID}})<br />
			{% for Phone in Sale.Customer.Contact.Phones.ContactPhone %}
			{{Phone.useType}}: {{Phone.number}}<br />
			{% endfor %}
			{{ _self.address(Sale.Customer.Contact) }}
		</dd>
	</dl>
{% endmacro %}

{% macro workorder_agreement(Sale) %}
	{% if Sale.Shop.ReceiptSetup.workorderAgree|length > 0 %}
	<!-- 
		@FIXME
		Should only print this work_order agreement if it's never been signed before.
		transaction->customer_id->printWorkorderAgreement($transaction->transaction_id)  -->
	
<div class="signature">
	<p>{{Sale.Shop.ReceiptSetup.workorderAgree|nl2br}}</p>
	<dl>
		<dt>Signature</dt>
		<dd><div class="signature_line"></div><br /> {{Sale.Customer.firstName}} {{Sale.Customer.lastName}}</dd>
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
		
		{% if Sale.ShipTo.shipNote|length == 0 %}
		<h5>Instructions</h5>
		<p>{{Sale.ShipTo.shipNote}}</p>
		{% endif %}
	</div>
	{% endif %}
{% endmacro %}

{% macro shipping_address(Customer,Contact) %}
<p>
	{% if Customer.company|length > 0 %}{{Customer.company}}<br>{% endif %}
	{% if Customer.company|length > 0 %}Attn:{% endif %} {{Customer.firstName}} {{Customer.lastName}}<br>
	{{ _self.address(Contact) }}
</p>
{% endmacro %}

{% macro address(Contact,delimiter) %}
	{% if delimiter|length == 0 %}{% set delimiter = '<br>' %}{% endif %}

	{% autoescape false %}
	{% for Address in Contact.Addresses.ContactAddress %}
		{% if loop.first and Address.address1 %}
			{{Address.address1}}{{delimiter}}
			{% if Address.address2|length > 0 %} {{Address.address2}}{{delimiter}}{% endif %}
			{{Address.city}}, {{Address.state}} {{Address.zip}} {{Address.country}}
		{% endif %}
	{% endfor %}
	{% endautoescape %}
{% endmacro %}

{% macro layaways(Customer,parameters) %}
	{% if Customer.Layaways and Customer.Layaways|length > 0 %}
		<table class="lines layaways">
			<tr><th colspan="2">Layaways</th></tr>
			{% for Line in Customer.Layaways.SaleLine %}{{ _self.line(Line,parameters)}}{% endfor %}
		</table>
		<table class="layways totals">
			<tr>
				<td>Subtotal</td>
				<td>{{Customer.metaData.layawaysSubtotalNoDiscount|money}}</td>
			</tr>
			{% if Customer.metaData.layawaysAllDiscounts>0.00 %}
			<tr>
				<td>Discounts</td>
				<td>{{Customer.metaData.layawaysAllDiscounts|money}}</td>
			</tr>
			{% endif %}
			<tr>
				<td>Tax</td>
				<td>{{Customer.MetaData.layawaysTaxTotal|money}}</td>
			</tr>
			<tr>
				<td>Total</td>
				<td>{{Customer.MetaData.layawaysTotal|money}}</td>
			</tr>
		</table>
	{% endif %}
{% endmacro %}

{% macro specialorders(Customer,parameters) %}
	{% if Customer.SpecialOrders|length > 0 %}
		<table class="lines specialorders">
			<tr><th colspan="2">Special Orders</th></tr>
			{% for Line in Customer.Layaways.SaleLine %}{{ _self.line(Line,parameters) }}{% endfor %}
		</table>
		<table class="specialorders totals">
			<tr>
				<td>Subtotal</td>
				<td>{{Customer.MetaData.specialOrdersSubtotalNoDiscount|mosformat('money')}}</td>
			</tr>
			{% if Customer.MetaData.specialOrdersAllDiscounts > 0 %}
				<tr>
					<td>Discounts</td>
					<td>{{Customer.MetaData.specialOrdersAllDiscounts|mosformat('money')}}</td>
				</tr>
			{% endif %}
			<tr>
				<td>Tax</td>
				<td>{{Customer.MetaData.specialOrdersTaxTotal|mosformat('money')}}</td>
			</tr>
			<tr>
				<td>Total</td>
				<td>{{Customer.MetaData.specialOrdersTotal|mosformat('money')}}</td>
			</tr>
		</table>
	{% endif %}
{% endmacro %}

{% macro workorders(Customer,parameters) %}
	{% if Customer.Workorders|length > 0 %}
		<table class="lines workorders">
			<tr>
				<th colspan="2">Open Workorders</th>
			</tr>
			{% for Line in Customer.WorkOrders.SaleLine %}
			<tr>
				<td>{{Line.name|nl2br}}</td>
				<td>{{Line.MetaData.workOrderTotal|money}}</td>
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