{% extends parameters.print ? "printbase" : "base" %}
{% block extrastyles %}
@page { margin: 0px; }
body {
  margin: 0;
  padding: 1px; <!-- You need this to make the printer behave -->
}
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

.receipt table td.amount { padding-left: 10px; }

.receipt table.sale { border-bottom: 1px solid black; }
.receipt table.sale thead th { border-bottom: 1px solid black; }

.receipt table div.line_description { font-weight: bold; }
.receipt table div.line_note { padding-left: 10px; }
.receipt table div.line_serial { padding-left: 10px; }

.receipt table.workorders div.line_description { font-weight: normal; padding-left: 10px; }
.receipt table.workorders div.line_note { font-weight: normal; padding-left: 10px; }
.receipt table.workorders div.line_serial { font-weight: normal; padding-left: 20px; }
.receipt table.workorders td.workorder div.line_note { font-weight: bold; padding-left: 0px; }

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

{% if Sale.Shop.ReceiptSetup.creditcardAgree|strlen > 0 and not parameters.gift_receipt and not parameters.email %}
	{% if parameters.force_cc_agree or parameters.print_workorder_agree %}
        {{ _self.store_receipt(Sale,parameters) }}
	{% else %}
	    {% for SalePayment in Sale.SalePayments.SalePayment %}
        	{% if SalePayment.CCCharge %}
                {{ _self.store_receipt(Sale,parameters) }}
        	{% endif %}
        {% endfor %}
    {% endif %}
{% endif %}

<!-- replace.email_custom_header_msg -->
<div class="receipt customer">
	{{ _self.ship_to(Sale) }}

	<div class="header">		
		{% if Sale.Shop.ReceiptSetup.logo|strlen > 0  %}
		<img src="{{Sale.Shop.ReceiptSetup.logo}}" width="{{Sale.Shop.ReceiptSetup.logoWidth}}" height="{{Sale.Shop.ReceiptSetup.logoHeight}}" class="logo">
		{% endif %}
		<h3>{{ Sale.Shop.name }}</h3>
	{% if Sale.Shop.ReceiptSetup.header|strlen > 0 %}
		{{Sale.Shop.ReceiptSetup.header|nl2br|raw}}
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

	{% if Sale.quoteID and Sale.Quote.notes|strlen > 0 %}<p class="note quote">{{Sale.Quote.notes|noteformat|raw}}</p>{% endif %}

	{% if Sale.Shop.ReceiptSetup.generalMsg|strlen > 0 %}<p class="note">{{ Sale.Shop.ReceiptSetup.generalMsg|noteformat|raw }}</p>{% endif %}

	{% if not parameters.gift_receipt %}
	<p class="thankyou">Merci {% if Sale.Customer %}{{Sale.Customer.firstName}} {{Sale.Customer.lastName}}{% endif %}!</p>
	{% endif %}

	<img height="50" width="250" class="barcode" src="/barcode.php?type=receipt&number={{Sale.ticketNumber}}">
</div>

<!-- replace.email_custom_footer_msg -->
{% endfor %}
{% endblock content %}


{% macro store_receipt(Sale,parameters) %}
<div class="receipt store">
	<div class="header">
		{{ _self.title(Sale,parameters) }}
		<p class="copy">Duplication du magasin</p>
		{{ _self.date(Sale) }}
	</div>
	
	{{ _self.sale_details(Sale) }}
	{{ _self.receipt(Sale,parameters) }}

	{% if Sale.quoteID and Sale.Quote.notes|strlen > 0 %}<p class="note quote">{{Sale.Quote.notes|noteformat|raw}}</p>{% endif %}

	{{ _self.cc_agreement(Sale) }}
	{{ _self.workorder_agreement(Sale) }}

	<img height="50" width="250" class="barcode" src="/barcode.php?type=receipt&number={{Sale.ticketNumber}}">	

	{{ _self.ship_to(Sale) }}
</div>
{% endmacro %}

{% macro lineDescription(Line) %}
	{% if Line.Item %}
		<div class='line_description'>
			{% autoescape true %}{{ Line.Item.description|nl2br }}{% endautoescape %}
		</div>
	{% endif %}
	{%if Line.Note %}
		<div class='line_note'>
			{% autoescape true %}{{ Line.Note.note|noteformat|raw }}{% endautoescape %}
		</div>
	{% endif %}
	{% if Line.Serialized %}
		{% for Serialized in Line.Serialized.Serialized %}
			<div class='line_serial'>
				Numero de séries: {{ Serialized.serial }} {{ Serialized.color }} {{ Serialized.size }}
			</div>
		{% endfor %}
	{% endif %}
{% endmacro %}

{% macro title(Sale,parameters) %}
<h1>
	{% if Sale.calcTotal >= 0 %}
		{% if Sale.completed == 'true' %}
			{% if parameters.gift_receipt %}Cadeau{%else%}Re&#231u{%endif%} De Vente
		{% elseif Sale.voided == 'true' %}
			Recu 
			<large>ANNULÉ</large>
		{% else %}
			Quovaisieas
			{% if not Sale.quoteID %}
				<large>(PAS UN REÇU)</large>
			{% endif %}
		{% endif %}
	{% else %}
		Recu de Rembourser
	{% endif %}
</h1>
{% endmacro %}

{% macro date(Sale) %}
<p class="date">
	{% if Sale.timeStamp %}
		{{Sale.timeStamp|correcttimezone|date('d/m/Y h:i:s ')}}
	{% else %}
		{{"now"|date('m/d/Y h:i:s A')}}
	{% endif %}
</p>
{% endmacro %}

{% macro sale_details(Sale) %}
<p>
	{% if Sale.quoteID > 0 %}# Devis: {{Sale.quoteID}}{% endif %}<br />
	# Facture: {{Sale.ticketNumber}}<br />
	{% if Sale.Register %}Caisse: {{Sale.Register.name}}<br />{% endif %}
	{% if Sale.Employee %}Employé: {{Sale.Employee.firstName}} {{Sale.Employee.lastName}}<br />{% endif %}
	{% if Sale.Customer %}
		{% if Sale.Customer.company|strlen > 0 %}
			Entreprise: {{Sale.Customer.company}}<br />
		{% endif %}
		Client: {{Sale.Customer.firstName}} {{Sale.Customer.lastName}}<br />
		<span class="indent">
		{% if Sale.Customer.Contact.Phones.ContactPhone.number|strlen > 0 %}
			Téléphone:
		{% endif %}
		{% for Phone in Sale.Customer.Contact.Phones.ContactPhone %}
			{{Phone.number}}<br />
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
	<th>{{ _self.lineDescription(Line) }}</th>
	<td class="quantity">{{Line.unitQuantity}}</td>
	<td class="amount">{% if not parameters.gift_receipt %}{{Line.calcSubtotal|number_format(2, '.')}}${% endif %}</td>
</tr>
{% endmacro %}

{% macro receipt(Sale,parameters) %}
{% if Sale.SaleLines %}
<table class="sale lines">
	<thead>
		<tr>
			<th>Produits</th>
			<th></th>
			<th class="amount">Prix</th>
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
  		<tr><td width="100%">Sous-total</td><td class="amount">{{Sale.calcSubtotal|number_format(2, '.')}}$</td></tr>
  		{% if Sale.calcDiscount > 0 %}<tr><td>Réductions</td><td class="amount">{{Sale.calcDiscount|number_format(2, '.')}}$</td></tr>{% endif %}
		{% for Tax in Sale.TaxClassTotals.Tax %}
		{% endfor %}
		<tr><td width="100%">T.P.S: [enter your T.P.S. number here]</td><td class="amount">{{Sale.calcTax1|number_format(2, '.')}}$</td></tr>
		<tr><td width="100%">T.V.Q: [enter your T.V.Q. number here]</td><td class="amount">{{Sale.calcTax2|number_format(2, '.')}}$</td></tr>
		<tr class="total"><td>Total</td><td class="amount">{{Sale.calcTotal|number_format(2, '.')}}$</td></tr>
	</tbody>
</table>
{% endif %}
{% endif %}

{% if Sale.completed == 'true' and not parameters.gift_receipt %}
	{% if Sale.SalePayments %}
		<h2>Paiements</h2>
		<table class="payments">
			{% for Payment in Sale.SalePayments.SalePayment %}
					{% if Payment.CreditAccount.giftCard == 'true' %}
						<!--  Gift Card -->
						{% if Payment.amount > 0 %}
						<tr >
						    <td>
								Gift Card Charge<br />
								New Balance:
							</td>
							<td class="amount">
							    {{Payment.amount|number_format(2, '.')}}$<br />
							    {{Payment.CreditAccount.balance|getinverse|number_format(2, '.')}}$
							</td>
						</tr>
						{% elseif Payment.amount < 0 and Sale.calcTotal <= 0 %}
						<tr><td>Refund To Gift Card</td><td class="amount">{{Payment.amount|number_format(2, '.')}}$</td></tr>
						{% elseif Payment.amount < 0 and Sale.calcTotal > 0 %}
						<tr><td>Gift Card Purchase</td><td class="amount">{{Payment.amount|number_format(2, '.')}}$</td></tr>
						{% endif %}
					{% elseif Payment.creditAccountID == 0 %}
						<!--  NOT Customer Account -->
						<tr>
							<td width="100%">
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
							<td class="amount">{{Payment.amount|number_format(2, '.')}}$</td>
						</tr>
    					{% elseif Payment.CreditAccount %}
    						<!-- Customer Account -->
    						<tr>
    						    {% if Payment.amount < 0 %}
    							<td>Account Deposit</td>
    							<td class="amount">{{Payment.amount|getinverse|number_format(2, '.')}}$</td>
                                {% else %}
        					    <td>Account Charge</td>
    							<td class="amount">{{Payment.amount|number_format(2, '.')}}$</td>
                                {% endif %}
    						</tr>
    					{% endif %}
			{% endfor %}
			<tr><td colspan="2"></td></tr>
		    {% for Payment in Sale.SalePayments.SalePayment %}
			    {% if Payment.PaymentType.name == 'Comptant' %}
				    <tr><td width="100%">Monnaie</td><td class="amount">{{Sale.change|number_format(2, '.')}}$</td></tr>
    			{% endif %}
			{% endfor %}
		</table>
	{% endif %}
	
	{% if Sale.Customer %}
		{{ _self.layaways(Sale.Customer,parameters.gift_receipt)}}
		{{ _self.specialorders(Sale.Customer,parameters.gift_receipt)}}
		{{ _self.workorders(Sale.Customer,parameters.gift_receipt)}}
	{% endif %}
	
	{% if Sale.Customer and not parameters.gift_receipt %}
		{% if Sale.Customer.CreditAccount and Sale.Customer.CreditAccount.MetaData.creditBalanceOwed > 0 or Sale.Customer.CreditAccount.MetaData.extraDeposit > 0 %}
			<h2>Dossier</h2>
			<table class="totals">
				{% if Sale.Customer.CreditAccount.MetaData.creditBalanceOwed > 0 %}
				<tr>
					<td width="100%">Montants Du</td>
					<td class="amount">{{ Sale.Customer.CreditAccount.MetaData.creditBalanceOwed|number_format(2, '.')}}$</td>
				</tr>
				{% elseif Sale.Customer.CreditAccount.MetaData.extraDeposit > 0 %}
				<tr>
					<td width="100%">Au Depôt</td>
					<td class="amount">{{ Sale.Customer.CreditAccount.MetaData.extraDeposit|number_format(2, '.')}}$</td>
				</tr>
				{% endif %}
			</table>
		{% endif %}
		{% if Sale.Customer.MetaData.getAmountToCompleteAll > 0 %}
			<table class="totals">
			<tr class="spacer total">
				<td width = "100%">Balance Manquant:</td>
				<td class="amount">-{{ Sale.Customer.MetaData.getAmountToCompleteAll|number_format(2, '.')}}$</td>
			</tr>
			</table>
		{% endif %}
	</table>
	{% endif %}

{% endif %}
{% endmacro %}

{% macro cc_agreement(Sale) %}
    {% if Sale.SalePayments.SalePayment.CCCharge %}
	{% if Sale.Shop.ReceiptSetup.creditcardAgree|strlen > 0 %}
	<p>{{Sale.Shop.ReceiptSetup.creditcardAgree|noteformat|raw}}</p>
	{% endif %}
	<dl class="signature">
		<dt>Signature:</dt>
		<dd>
			{{Sale.Customer.firstName}} {{Sale.Customer.lastName}}<br />
			{% for Phone in Sale.Customer.Contact.Phones.ContactPhone %}
			{{Phone.useType}}: {{Phone.number}}<br />
			{% endfor %}
			{{ _self.address(Sale.Customer.Contact) }}
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
		<h4>Address D'expédition</h4>
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

{% macro layaways(Customer,parameters) %}
	{% if Customer.Layaways and Customer.Layaways|length > 0 %}
	<h2>Mises de Côté</h2>
	<table class="lines layaways">
		{% for Line in Customer.Layaways.SaleLine %}{{ _self.line(Line,parameters)}}{% endfor %}
	</table>
	<table class="layways totals">
		<tr>
			<td width="100%">Sous-total</td>
			<td class="amount">{{Customer.MetaData.layawaysSubtotalNoDiscount|number_format(2, '.')}}$</td>
		</tr>
		{% if Customer.MetaData.layawaysAllDiscounts>0.00 %}
		<tr>
			<td width="100%">Réductions</td>
			<td class="amount">{{Customer.MetaData.layawaysAllDiscounts|number_format(2, '.')}}$</td>
		</tr>
		{% endif %}
		<tr>
			<td width="100%">Tax</td>
			<td class="amount">{{Customer.MetaData.layawaysTaxTotal|number_format(2, '.')}}$</td>
		</tr>
		<tr class="total">
			<td width="100%">Total</td>
			<td class="amount">{{Customer.MetaData.layawaysTotal|number_format(2, '.')}}$</td>
		</tr>
	</table>
	{% endif %}
{% endmacro %}

{% macro specialorders(Customer,parameters) %}
	{% if Customer.SpecialOrders|length > 0 %}
	<h2>Commandes Spéciales</h2>
	<table class="lines specialorders">
		{% for Line in Customer.SpecialOrders.SaleLine %}{{ _self.line(Line,parameters) }}{% endfor %}
	</table>
	<table class="specialorders totals">
		<tr>
			<td width="100%">Sous-Total</td>
			<td class="amount">{{Customer.MetaData.specialOrdersSubtotal|number_format(2, '.')}}$</td>
		</tr>
		{% if Customer.MetaData.specialOrdersAllDiscounts > 0 %}
			<tr>
				<td width="100%">Réductions</td>
				<td class="amount">{{Customer.MetaData.specialOrdersAllDiscounts|getinverse|number_format(2, '.')}}$</td>
			</tr>
		{% endif %}
		<tr>
			<td width="100%">Tax</td>
			<td class="amount">{{Customer.MetaData.specialOrdersTaxTotal|number_format(2, '.')}}$</td>
		</tr>
		<tr class="total">
			<td width="100%">Total</td>
			<td class="amount">{{Customer.MetaData.specialOrdersTotal|number_format(2, '.')}}$</td>
		</tr>
	</table>
	{% endif %}
{% endmacro %}

{% macro workorders(Customer,parameters) %}
	{% if Customer.Workorders|length > 0 %}
		<h2>Fiches Reparations Ouvertes
Réparations</h2>
		<table class="lines workorders">
			{% for Line in Customer.Workorders.SaleLine %}
				<tr>
					{% if Line.MetaData.workorderTotal %}
						<td class="workorder" colspan="2">{{ _self.lineDescription(Line) }}</td>
					{% else %}
						<td >{{ _self.lineDescription(Line) }}</td>
						<td class="amount">{{Line.calcSubtotal|number_format(2, '.')}}$</td>
					{% endif %}
				</tr>
			{% endfor %}
		</table>
		{% if Customer.MetaData.workordersTotal > 0 %}
			<table class="workorders totals">
				<tr>
					<td width="100%">Sous-total</td>
					<td class="amount">{{Customer.MetaData.workordersSubtotalNoDiscount|number_format(2, '.')}}$</td>
				</tr>
				{% if Customer.MetaData.specialOrdersAllDiscounts > 0 %}
					<tr>
						<td width="100%">Réductions</td>
						<td class="amount">{{Customer.MetaData.workordersAllDiscounts|number_format(2, '.')}}$</td>
					</tr>
				{% endif %}
				<tr>
					<td width="100%">Tax</td>
					<td class="amount">{{Customer.MetaData.workordersTaxTotal|number_format(2, '.')}}$</td>
				</tr>
				<tr class="total">
					<td width="100%">Total</td>
					<td class="amount">{{Customer.MetaData.workordersTotal|number_format(2, '.')}}$</td>
				</tr>
			</table>
		{% endif %}
	{% endif %}
{% endmacro %}
