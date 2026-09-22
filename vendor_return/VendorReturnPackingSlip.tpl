{% extends parameters.print ? "printbase" : "base" %}
{% block extrastyles %}
/*! normalize.css v2.0.1 | MIT License | git.io/normalize */
header { display: block }

html {
	font-family: sans-serif;
	-webkit-text-size-adjust: 100%;
	-ms-text-size-adjust: 100%;
}

body { margin: 0 }

b,
strong { font-weight: bold }

small { font-size: 80% }

table {
	border-collapse: collapse;
	border-spacing: 0;
}

* { box-sizing: border-box }

@media print {
	html,
	body { font-size: 75% }
}

@media screen {
	.document html,
	body { margin: 1rem }
}

body { font-family: "Open Sans", Helvetica, Arial, Verdana, sans-serif }

h2,
h3,
h4,
h5,
h6 {
	font-weight: 400;
	color: #000;
	margin: .5em 0 .25em;
}

h3,
h4,
h5,
h6 {
	font-weight: 600;
}

h2 small {
	font-weight: 400;
	font-size: 75%;
	color: #666;
}

h5,
h6 { color: #444 }

h2 { font-size: 2rem }

h3 { font-size: 1.5rem }

h4 { font-size: 1.25rem }

h5 { font-size: 1rem; }

h6 {
	font-size: .875rem;
	text-transform: uppercase;
}

p { font-size: 1rem }

p.xs { font-size: .75rem }

p.s { font-size: .875rem }

.row { overflow: hidden }

@media (min-width: 480px) {
	.col-md-6 { width: 50% }
}

@media (min-width: 480px) {
	.col-md-6 { float: left }

	.col-spacerL-md6 { margin-left: 50% }
}

table.document { width: 100% }

table.document td,
table.document th {
	padding: .375rem;
	vertical-align: top;
}

table.document th {
	text-align: left;
	text-transform: uppercase;
}

table.document td.money { text-align: right }

table.document td.money:before { margin-right: .125rem; }

table.document thead {
	border-bottom: 1px solid #666;
	border-top: 1px solid #666;
}

table.document thead th {
	padding-top: .25rem;
	padding-bottom: .25rem;
	background-color: #f8f8f8;
	font-size: .75rem;
	line-height: 1.5;
}

table.document tbody td { border: 1px solid #666 }

table.document tbody td.money {
	position: relative;
	padding-left: .5rem;
}

table.document tbody td.money:before {
	position: absolute;
	left: .5rem;
}

table.document tfoot {
	border-top: 4px solid #444;
	font-weight: bold;
}

table.document tfoot td {
	font-weight: bold;
}

table.document tfoot .total {
	font-size: 1.125rem;
}
table.document tfoot .leading-row-gap td,
table.document tfoot .leading-row-gap th {
	padding-top: 15px;
}
table.document tfoot .minor td,
table.document tfoot .minor th {
	font-weight: normal;
	line-height: 1;
	text-transform: none;
}

* { box-sizing: border-box }

.u-margin-An { margin: 0 }

.u-margin-Tn { margin-top: 0 }

.u-margin-Bxl { margin-bottom: 30px }

.u-margin-Vn {
	margin-top: 0;
	margin-bottom: 0;
}

.u-margin-Vxxs {
	margin-top: 4px;
	margin-bottom: 4px;
}

html { height: 100% }
{% endblock extrastyles %}

{% block content %}
{% for VendorReturn in VendorReturns %}
<header class="col-spacerL-md6 col-md6 u-margin-Bxl">
	<h2 class="u-margin-Vn">
		Return to Vendor <small>#{{ VendorReturn.vendorReturnID }}</small>
	</h2>
	{% if VendorReturn.sentDate %}
	<h5>Date Sent: {{ VendorReturn.sentDate|date('Y-m-d', false) }}</h5>
	{% endif %}
	{% if VendorReturn.refNum|strlen > 0 %}
	<h5>Reference# {{ VendorReturn.refNum }}</h5>
	{% endif %}
</header>

<div class="row">
	<div class="col-md-6">
		<h6 class="u-margin-Vn">From</h6>
		<h4 class="u-margin-Vxxs">{{ VendorReturn.Shop.name }}</h4>
		{% for ContactAddress in VendorReturn.Shop.Contact.Addresses.ContactAddress %}
			<p class="u-margin-Tn s">
				{{ ContactAddress|address|raw }}
		{% endfor %}
		{% if VendorReturn.Shop.Contact.Phones.ContactPhone.number %}
			<p class="u-margin-Tn s">
			{{ VendorReturn.Shop.Contact.Phones|phonelist|raw}}
			</p>
		{% endif %}
	</div>
	{% if VendorReturn.Vendor %}
	<div class="col-md-6">
		<h6 class="u-margin-Vn">Vendor</h6>
		<h4 class="u-margin-Vxxs">{{ VendorReturn.Vendor.name }}</h4>
		<p class="margin-top-none">
			{% for VendorRep in VendorReturn.Vendor.Reps.VendorRep %}
				<strong>ATTN:</strong> {{ VendorRep.firstName }}
				 {{ VendorRep.lastName }}
				{% if not loop.last %}<br>{% endif %}
			{% endfor %}

			{% if VendorReturn.Vendor.accountNumber|strlen > 0 %}
			<strong>Account #</strong> {{ VendorReturn.Vendor.accountNumber }}
			{% endif %}
		</p>
		{% for ContactAddress in VendorReturn.Vendor.Contact.Addresses.ContactAddress %}
		<p class="u-margin-Tn s">
			{{ ContactAddress|address|raw }}
		</p>
		{% endfor %}
		{% if VendorReturn.Vendor.Contact.Phones.ContactPhone.number %}
		<p class="u-margin-Tn s">
			{{ VendorReturn.Vendor.Contact.Phones|phonelist|raw}}
		</p>
		{% endif %}
	</div>
	{% endif %}
</div>
<h3>Details</h3>
<table class="document">
	<thead>
		<tr>
			<th>Vendor ID</th>
			<th>Qty</th>
			<th>Description</th>
			<th>PO</th>
			<th {% if view_cost == false %} colspan="3" {% endif %}>Reason</th>
            {% if view_cost == true %}
                <th>Unit Cost</th>
                <th>Total</th>
            {% endif %}
		</tr>
	</thead>
	{% for VendorReturnItem in VendorReturn.VendorReturnItems.VendorReturnItem %}
		{{ _self.vendorReturnItemRow(VendorReturn, VendorReturnItem, view_cost) }}
	{% endfor %}
	{{ _self.totals(VendorReturn, view_cost) }}
</table>

{% if VendorReturn.Note.note|strlen > 0 %}
<h3>Notes</h3>
<p class="s">{{ VendorReturn.Note.note|noteformat|raw }}</p>
{% endif %}

{% endfor %}
{% endblock content %}

{% macro vendorReturnItemRow(VendorReturn, VendorReturnItem, view_cost) %}
	{% set line_total = (VendorReturnItem.cost|floatval *
		VendorReturnItem.quantity) %}
	<tr>
		<td>
          {% for ItemVendorNum in VendorReturnItem.Item.ItemVendorNums.ItemVendorNum %}
            {% if (VendorReturn.vendorID|number_format) == (ItemVendorNum.vendorID|number_format) %}
              {{ ItemVendorNum.value }}
            {% endif %}
          {% endfor %}
        </td>
		<td>{{ VendorReturnItem.quantity}}</td>
		<td>{{ VendorReturnItem.Item.description }}</td>
		<td>
			{% if VendorReturnItem.orderID == '0' %}
				N/A
			{% else %}
				{{ VendorReturnItem.orderID}}
			{% endif %}
		</td>
		<td{% if view_cost == false %} colspan="3" {% endif %}>{{ VendorReturnItem.VendorReturnItemReason.reason }}</td>
        {% if view_cost == true %}
            <td class="money">{{ VendorReturnItem.cost|money }}</td>
            <td class="money">{{ line_total|money }}</td>
        {% endif %}
	</tr>
{% endmacro %}

{% macro totals(VendorReturn, view_cost) %}
	{% set total_quantity = 0|intval %}
	{% for VendorReturnItem in VendorReturn.VendorReturnItems.VendorReturnItem %}
		{% set total_quantity = total_quantity + VendorReturnItem.quantity|intval %}
	{% endfor %}

	<tfoot>
        {% if view_cost == true %}
            <tr class="minor leading-row-gap">
                <th>Subtotal</th>
                <td>{{ total_quantity }}</td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td class="money">{{ VendorReturn.subtotal|money }}</td>
            </tr>
        {% endif %}
		{% if VendorReturn.shipCost > 0 %}
		<tr class="minor">
			<th>Shipping</th>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td class="money">{{ VendorReturn.shipCost|money }}</td>
		</tr>
		{% endif %}
		{% if VendorReturn.otherCost != 0 %}
		<tr class="minor">
			<th>Other (+/-)</th>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td class="money">{{ VendorReturn.otherCost|money }}</td>
		</tr>
		{% endif %}
        {% if view_cost == true %}
            <tr class="total">
                <th>Totals</th>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td class="money">{{ VendorReturn.total|money }}</td>
            </tr>
        {% endif %}
	</tfoot>
{% endmacro %}
