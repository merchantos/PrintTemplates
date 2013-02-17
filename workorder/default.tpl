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
		display: block;
		margin: 0 auto;
		font-size: 24pt;
		width: 2em;
		padding: 10px
    }

	.header_item h2
	{
		margin: 0px;
		padding: 0px;
		font-size: 11pt;
	}

	table.lines
	{
		width: 100%;
	}

	table.lines th
	{
		font-size: 10pt;
		border-bottom: 1px solid #000;
		margin-bottom: 3px;
		text-align: left;
	}
	table.lines td.quantity
	{
		text-align: right;
	}
	table.lines td.notes
	{ 
		margin-left: 15px;
	}

	table.lines td.barcode
	{
		text-align: right;
		padding: 3px;
		border: 1px solid #000;
	}

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
{% endblock extrastyles %}

{% block content %}
	{% for Workorder in Workorders %}
	<div class="workorder {% if not loop.last %} pagebreak{% endif %}">
		<div class="header">
				<h1>Work Order <strong>#{{Workorder.workorderID}}</strong></h1>
		</div>
		<div class="header_item">
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
				<td class="charge"> $0.00
				{% endif %}
				{% if WorkorderItem.warranty == 'false' %}
				<td class="charge">	
				    {{ (WorkorderItem.SaleLine.calcSubtotal - WorkorderItem.SaleLine.calcLineDiscount) | money}}
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
				    <br>{{WorkorderLine.Discount.name}} ({{WorkorderLine.SaleLine.calcLineDiscount|money}})
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
				<td class="charge">{{WorkorderLine.SaleLine.calcTotal | money}}</td>
				{% endif %}
			</tr>
			{% endfor %}

		</table>
		
		{% if Workorder.note|length > 1 %}
		<div class="notes">
			<h3>Notes:</h3>
			{{ Workorder.note }}
		</div>
		{% endif %}
		
		<img height="50" width="250" class="barcode" src="/barcode.php?type=receipt&number={{Workorder.systemSku}}">
	</div>
	{% endfor %}
{% endblock content %}