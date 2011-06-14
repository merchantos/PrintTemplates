{% extends parameters.print ? "printbase" : "base" %}
{% block extrastyles %}
	.pagebreak
	{
		page-break-after: always;
	}
	.transfer
	{
		margin: 10px;
	}
	.transfer_datenow
	{
		float: right;
		font-size: 9pt;
	}
	.transfer h1
	{
		font-size: 12pt;
	}
	.endheader
	{
		clear: both;
	}
	.header_item
	{
		clear: both;
		float: left;
		font-size: 9pt;
		margin-right: 5px;
		margin-bottom: 5px;
		max-width: 400px;
	}
	.header_item h1
	{
		margin: 0px;
		padding: 0px;
		font-size: 12pt;
	}
	.header_item_body
	{
		border: 1px solid #000;
		padding: 5px;
	}
	.header_item h2
	{
		margin: 0px;
		padding: 0px;
		font-size: 11pt;
	}
	.header_item h3
	{
		margin: 0px;
		padding: 0px;
		font-size: 10pt;
	}
	.address, .phone
	{
		margin-left: 5px;
		margin-bottom: 5px;
	}
	.address_city, .address_state, .address_zip
	{
		display: inline;
	}
	table.lines th
	{
		font-size: 10pt;
		border-bottom: 1px solid #000;
		margin-bottom: 3px;
	}
	table.lines td.quantity
	{
		text-align: right;
	}
	table.lines td.barcode
	{
		text-align: right;
		padding: 3px;
		border: 1px solid #000;
	}
{% endblock extrastyles %}
{% block content %}
	{% for Transfer in Transfers %}
		<div class="transfer {% if not loop.last %} pagebreak{% endif %}">
			<div class="header">
				<div class="transfer_datenow">{{ "now"|date("m/d/y h:i a") }}</div>
				<h1>Transfer #{{ Transfer.transferID }}, Sent On {{ Transfer.TransferFrom.sentOn|date("m/d/y") }}, Needed By {{ Transfer.TransferTo.needBy|date("m/d/y") }}</h1>
				<div class="header_item">
					<h1>Sent From</h1>
					<div class="header_item_body">
						<h2>{{ Transfer.TransferFrom.Shop.name }}</h2>
						<h3>c/o {{ Transfer.TransferFrom.Employee.firstName }} {{ Transfer.TransferFrom.Employee.lastName }}</h3>
						{% for ContactAddress in Transfer.TransferFrom.Shop.Contact.Addresses.ContactAddress %}
							<div class="address">
								<div class="address_address1">{{ ContactAddress.address1 }}</div>
								<div class="address_address2">{{ ContactAddress.address2 }}</div>
								<div class="address_city">{{ ContactAddress.city }}, </div>
								<div class="address_state">{{ ContactAddress.state }}</div>
								<div class="address_zip">{{ ContactAddress.zip }}</div>
							</div>
						{% endfor %}
						{% for ContactPhone in Transfer.TransferFrom.Shop.Contact.Phones.ContactPhone %}
							<div class="phone">
								{{ ContactPhone.useType }}: {{ ContactPhone.number }}
							</div>
						{% endfor %}
					</div>
				</div>
				<div class="header_item">
					<h1>Sent To</h1>
					<div class="header_item_body">
						<h2>{{ Transfer.TransferTo.Shop.name }}</h2>
						<h3>c/o {{ Transfer.TransferTo.Employee.firstName }} {{ Transfer.TransferTo.Employee.lastName }}</h3>
						{% for ContactAddress in Transfer.TransferTo.Shop.Contact.Addresses.ContactAddress %}
							<div class="address">
								<div class="address_address1">{{ ContactAddress.address1 }}</div>
								<div class="address_address2">{{ ContactAddress.address2 }}</div>
								<div class="address_city">{{ ContactAddress.city }}, </div>
								<div class="address_state">{{ ContactAddress.state }}</div>
								<div class="address_zip">{{ ContactAddress.zip }}</div>
							</div>
						{% endfor %}
						{% for ContactPhone in Transfer.TransferTo.Shop.Contact.Phones.ContactPhone %}
							<div class="phone">
								{{ ContactPhone.useType }}: {{ ContactPhone.number }}
							</div>
						{% endfor %}
					</div>
				</div>
				<div class="header_item">
					<h1>Notes</h1>
					<div class="header_item_body">
						{{ Transfer.note }}
					</div>
				</div>
				<div class="endheader"></div>
			</div>
			<table class="lines" border=0 cellpadding=0 cellspacing=3>
				<tr>
					<th>Item</th>
					<th>Quantity</th>
					<th>System ID</th>
				</tr>
				{% for TransferItem in Transfer.TransferItems.TransferItem %}
					<tr>
						<td class="description">{{ TransferItem.Item.description }}</td>
						<td class="quantity">{% if Transfer.sent=='true' %}{{ TransferItem.sent }}{% else %}{{ TransferItem.toSend }}{% endif %}</td>
						<td class="barcode">
							<img height="40" width="200" src="/barcode.php?type=label&number={{ TransferItem.Item.systemSku }}&noframe=1">
						</td>
					</tr>
				{% endfor %}
			</table>
		</div>
	{% endfor %}
{% endblock content %}
