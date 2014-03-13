{% extends parameters.print ? "printbase" : "base" %}
{% block extrastyles %}
  .pagebreak
	{
		page-break-after: always;
	}
	.workorder
	{
		margin: 10px;
	}
	.header h1
	{
		text-align: center;
		font-size: 12pt;
	}
	.header h1 strong {
		border: 3px solid black;
		font-size: 24pt;
		padding: 10px;
	}

	.detail h2 {
		margin: 0px;
		padding: 0px;
		font-size: 11pt;
	}
	.detail { margin-bottom: 1em; }

	table.lines, table.totals { 
	    width: 100%; 
	    border-spacing:0;
        border-collapse:collapse;
	}
    table.lines td, table.totals td {
        padding: 4px 0;
    }
	table.lines th {
		font-size: 10pt;
		border-bottom: 1px solid #000;
		margin-bottom: 3px;
		text-align: left;
	}
	table.lines td.notes { margin-left: 15px; }
	
	table td.amount { 
	    width: 10%; 
	    text-align: left;
	}
	
	table.totals { 
	    text-align: right; 
	    border-top: 1px solid #000;
	}
	table.totals tr td:first-child { padding-right: 10px; }
	table tr.total td { font-weight: bold; }

	.notes {
		overflow: hidden;
		margin: 0 0 1em;
	}
	.notes h1 { margin: 1em 0 0; }

	img.barcode 
	{
		display: block;
		margin: 2em auto; 
	}

	.signature {
		font-size: 1em;
		font-weight: 500;
	}

	.signature dl.signature {
		position: relative;
		width: 50%;
	}

	.signature dl.signature dd {
		position: absolute;
		border-top: 1px solid;
		width: 75%;
		left: 3em;
		text-align: right;
	}
{% endblock extrastyles %}

{% block content %}
	{% for Workorder in Workorders %}
	<div class="workorder {% if not loop.last %} pagebreak{% endif %}">
		<div class="header">
			{% if Workorder.Shop.ReceiptSetup.hasLogo == "true" %}
				<img class="header" src="{{ Workorder.Shop.ReceiptSetup.logo }}" height="{{ Workorder.Shop.ReceiptSetup.logoHeight }}" width="{{ Workorder.Shop.ReceiptSetup.logoWidth }}">
			{% endif %}
			<h1>Work Order</h1>
			<h1><strong>#{{Workorder.workorderID}}</strong></h1>
		</div>
		<div class="detail">
			<h2>Customer: {{ Workorder.Customer.lastName}}, {{ Workorder.Customer.firstName}}</h2>
			<h2>Started: {{Workorder.timeIn|correcttimezone|date ("m/d/y h:i a")}}</h2>
			<h2>Due on: {{Workorder.etaOut|correcttimezone|date ("m/d/y h:i a")}}</h2>
		</div>

		<table class="lines">
			<tr>
				<th>Item/Labor</th>
				<th>Notes</th>
				{% if parameters.type == 'invoice' %}<th>Charge</th>{% endif %}
			</tr>
			{% for WorkorderItem in Workorder.WorkorderItems.WorkorderItem %}
			<tr>
				{% if WorkorderLine.itemID != 0 %}
				<td class="description"></td>
				{% else %}
				<td class="description">
				    {% if WorkorderLine.unitQuantity > 0 %}
				    {{ WorkorderLine.unitQuantity }} &times; 
				    {% endif %}
				    {{ WorkorderItem.Item.description }}
				    
				    {% if WorkorderItem.Discount %}
				    <br>{{WorkorderItem.Discount.name}} ({{WorkorderItem.SaleLine.calcLineDiscount|money}})
				    {% endif %}
				</td>
				{% endif %}
				<td class="notes">{{ WorkorderItem.note }}</td>
				{% if parameters.type == 'invoice' %}
				{% if WorkorderItem.warranty == 'true' %}
				<td class="amount"> $0.00
				{% endif %}
				{% if WorkorderItem.warranty == 'false' %}
				<td class="amount">	
				    {{ WorkorderItem.SaleLine.calcSubtotal | money}}
				<td>
				{% endif %}
				{% endif %}
			</tr>
			{% endfor %}
			{% for WorkorderLine in Workorder.WorkorderLines.WorkorderLine %} <!--this loop is necessary for showing labor charges -->
			<tr>
				{% if WorkorderLine.itemID != 0 %}
				<td class="description">
				    {{ WorkorderLine.Item.description }}
				    
				    {% if WorkorderLine.Discount %}
				    <br>Discount: {{WorkorderLine.Discount.name}} ({{ WorkorderLine.SaleLine.calcLineDiscount | money}})
				    {% endif %}
				</td>
				<td class="notes">{{ WorkorderLine.note }}</td>
				{% else %}
				<td class="notes" colspan="2">
				    {{ WorkorderLine.note }}
				    
				    {% if WorkorderLine.Discount %}
				    <br>{{WorkorderLine.Discount.name}} ({{WorkorderLine.SaleLine.calcLineDiscount|money}})
				    {% endif %}
				</td>
				{% endif %}
				{% if parameters.type == 'invoice' %}
				<td class="amount">{{WorkorderLine.SaleLine.calcSubtotal | money}}</td>
				{% endif %}
			</tr>
			{% endfor %}
		</table>

        <table class="totals">
        	<tbody>
                <tr><td>Labor</td><td class="amount">{{Workorder.MetaData.labor|money}}</td></tr>
                <tr><td>Parts</td><td class="amount">{{Workorder.MetaData.parts|money}}</td></tr>
          		{% if Workorder.MetaData.discount > 0 %}<tr><td>Discounts</td><td class="amount">-{{Workorder.MetaData.discount|money}}</td></tr>{% endif %}
                <tr><td>Tax</td><td class="amount">{{Workorder.MetaData.tax|money}}</td></tr>
        		<tr class="total"><td>Total</td><td class="amount">{{Workorder.MetaData.total|money}}</td></tr>
        	</tbody>
        </table>
		
		{% if Workorder.note|escape|length > 0 %}
		<div class="notes">
			<h3>Notes:</h3>
			{{ Workorder.note }}
		</div>
		{% endif %}

		{% if Workorder.Shop.ReceiptSetup.workorderAgree|length > 0 %}
			<div class="signature">
				<p>{{Workorder.Shop.ReceiptSetup.workorderAgree|noteformat|raw}}</p>
				<dl class="signature">
					<dt>Signature:</dt>
					<dd>{{Workorder.Customer.firstName}} {{Workder.Customer.lastName}}</dd>
				</dl>
			</div>
		{% endif %}

		<img height="50" width="250" class="barcode" src="/barcode.php?type=receipt&number={{Workorder.systemSku}}">
	</div>
	{% endfor %}
{% endblock content %}
