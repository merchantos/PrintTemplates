{#
                            ***Begin Custom Options***
Set any of the options in this section from 'false' to 'true' in order to enable them in the template
#}

{% set chrome_right_margin_fix = false %}					{# Fixes a potential issue where the right side of receipts are cut off in Chrome #}
{% set firefox_margin_fix = false %}							{# Fixes issue with margins cutting off when printing on a letter printer on a Mac #}

{% set itemized_hours_labor = false %}						{# Shows time spent on Labor item if time spent is present in the charge #}
{% set per_line_subtotal = false %}								{# Displays Subtotals for each Sale Line (ex. 1 x $5.00) #}
{% set employee_name_on_labor_charges = false %}	{# Display Employee name on Labor Charges #}
{% set make_work_order_number_small = false %}		{# Makes work order number inline with the header #}
{% set remove_logo = false %}											{# Removes logo from receipt #}

{% set tag_header_information = false %}					{# Shows shop header information on Tags #}
{% set notes_on_tag_only = false %}								{# Displays notes on tags only (these will still show up in the Sales screen when ringing out the Work Order) #}

{% set hide_work_order_item = false %}						{# Removes the Start and end date from receipts #}
{% set hide_status = false %}											{# Removes the Status receipts #}
{% set hide_warranty = false %}										{# Removes warranty line from receipts #}
{% set hide_start_and_date = false %}							{# Removes the Start and end date from receipts #}

{% set hide_employee = false %}										{# Removes the the employee from the Work order header #}
{% set hide_Work_Order_Agreement = false %}				{# Removes the the employee from the Work order header #}


{% set hide_barcode = false %}										{# Removes barcode from bottom of receipts #}
{% set hide_barcode_sku = false %}								{# Remove the System ID from displaying at the bottom of barcdoes #}

{% set logo_width = '225px' %}										{# Default width is 225px. A smaller number will scale logo down #}
{% set multi_shop_logos = false %}								{# Allows multiple logos to be added for separate locations when used with options below #}

{% set minimal_mode = false %}

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
    {% if chrome_right_margin_fix == true %}
        margin-right: .13in;
    {% endif %}
    {% if firefox_margin_fix == true %}
        margin: 25px;
    {% endif %}
    padding: 1px; 
}

.workorder {
	margin: 0px;
	font: normal 10pt 'Helvetica Neue',Helvetica,Arial,sans-serif;
}

.header {
	text-align: center;
	{% if minimal_mode == false %}
		margin-bottom: 30px;
	{% else %}
		margin-bottom: 10px;
	{% endif %}
}

.header p {
	margin: 0;
}

.header h1 {
	text-align: center;
	font-size: 12pt;
	margin-bottom: 0;
}

.header h3 {
	font-size: 10pt;
	margin: 0;
}

.header h1 strong {
	border: 3px solid black;
	font-size: 24pt;
	padding: 10px;
}

.header img {
	display: block;
	margin: 8px auto 4px;
}

.detail {
	margin-bottom: 1em;
}

.detail h2, .detail h3 {
	margin: 0px 0px 10px 0px;
	padding: 0px;
	{% if minimal_mode == false %}
		font-size: 11pt;
	{% else %}
		font-size: 10pt;
	{% endif %}
}

.detail p {
	margin: 0;
}

.workOrderItem {
	font-size: 15px;
	font-weight: bold;
}

table {
	width: 100%;
	border-collapse:collapse;
	text-align: right;
}

table th {
	border-bottom: 1px solid #000;
}

table th.specialorder {
	padding-top: 10px;
	text-align: left;
}

table th.description {
	text-align: left;
}

table td.description {
	font-weight: bold;
	text-align: left;
	width: 100%;
}


table td.item_fee_line_name {
	text-align: left;
	padding-left: 10px;
}

table .description small {
	font-weight: normal;
}

table td.quantity, table th.quantity {
    text-align: center;
    white-space: nowrap;
}

table td.amount {
	padding-left: 10px;
}

table div.line_description {
	text-align: left;
	font-weight: bold;
}

table div.line_note {
	text-align: left;
	font-weight: normal;
}

table.totals td {
	margin: 0;
	width: 100%;
}

table.totals {
	text-align: right;
	border-top: 1px solid #000;
}

table.totals tr.total td {
	font-weight: bold;
}

.notes {
	overflow: hidden;
	margin: 0 0 1em;
}

.notes h3 {
	{% if minimal_mode == true %}
		font-size: 10pt;
	{% endif %}
}

.workorderAgree {
	margin-bottom: 40px;
	{% if minimal_mode == true %}
		font-size: 9pt;
	{% endif %}
}

img.barcode {
	display: block;
	{% if minimal_mode == false %}
		margin: 2em auto;
	{% else %}
		margin: 0px auto;
	{% endif %}
}

{% endblock extrastyles %}


{% block content %}
	<!-- replace.email_custom_header_msg -->
	{% for Workorder in Workorders %}
		<div class="workorder {% if not loop.last %} pagebreak{% endif %}">

			<div class="header">
				{% if parameters.type != 'shop-tag' or tag_header_information == true %}
					{% if minimal_mode or remove_logo == false %}
						{% set logo_printed = false %}
				        {% if multi_shop_logos == true %}
				            {% for shop in shop_logo_array %}
				                {% if shop.name == Workorder.Shop.name %}
				                    {% if shop.logo_url|strlen > 0 %}
				                        <img src="{{ shop.logo_url }}" width={{ logo_width }}>
				                        {% set logo_printed = true %}
				                    {% endif %}
				                {% endif %}
				            {% endfor %}
				        {% elseif Workorder.Shop.ReceiptSetup.hasLogo == 'true' %}
				            <img src="{{ Workorder.Shop.ReceiptSetup.logo }}" width={{ logo_width }}>
				            {% set logo_printed = true %}
				        {% endif %}
				    {% endif %}
			        {% if logo_printed == false %}
			            <h3>{{ Workorder.Shop.name }}</h3>
			        {% endif %}
					{% if Workorder.Shop.ReceiptSetup.header|strlen > 0 %}
						{{ Workorder.Shop.ReceiptSetup.header|nl2br|raw }}
					{% else %}
						<p>{{ Workorder.Shop.Contact.Addresses.ContactAddress.address1 }}</p>
						<p>{{ Workorder.Shop.Contact.Addresses.ContactAddress.address2 }}</p>
						<p>{{ Workorder.Shop.Contact.Addresses.ContactAddress.city }}, {{ Workorder.Shop.Contact.Addresses.ContactAddress.state }} {{ Workorder.Shop.Contact.Addresses.ContactAddress.zip }}</p>
						<p>{{ Workorder.Shop.Contact.Phones.ContactPhone.number }}</p>
					{% endif %}
				{% endif %}
				{% if minimal_mode == true %}
					<h1 id="receiptTypeTitle">Work Order #{{ Workorder.workorderID }}</h1>
					{{ _self.date(Workorder) }}
				{% else %}
						{% if make_work_order_number_small == true %} 
							<h1 id="receiptTypeTitle">Work Order #{{ Workorder.workorderID }}</h1>
							{{ _self.date(Workorder) }}
						{% elseif make_work_order_number_small == false %}	
							<h1 id="receiptTypeTitle">Work Order</h1>
							{{ _self.date(Workorder) }}
							<br />
							<h1 id="receiptTypeId"><strong>#{{ Workorder.workorderID }}</strong></h1>
							<br />
						{% endif %}
				{% endif %}
				{% if parameters.type == 'shop-tag' %}
					{% if Workorder.hookIn|strlen > 0 or Workorder.hookOut|strlen > 0 %}
						<h1 style="margin-top:20px;">Hook In: {{Workorder.hookIn}} <br />
						Hook Out: {{Workorder.hookOut}}</h1>
					{% endif %}
				{% endif %}
			</div>

			<div class="detail">
				<h3>Customer:</h3>
				<p id="customerName">{{ Workorder.Customer.firstName}} {{ Workorder.Customer.lastName}}</p>
				<p id="customerAddress1">{{ Workorder.Customer.Contact.Addresses.ContactAddress.address1 }}</p>
				<p id="customerAddress2">{{ Workorder.Customer.Contact.Addresses.ContactAddress.address2 }}</p>
				<p id="customerAddressCity">
				  {{ Workorder.Customer.Contact.Addresses.ContactAddress.city }}{% if Workorder.Customer.Contact.Addresses.ContactAddress.city and (Workorder.Customer.Contact.Addresses.ContactAddress.state or Workorder.Customer.Contact.Addresses.ContactAddress.zip) %},{% endif %}
				  {{ Workorder.Customer.Contact.Addresses.ContactAddress.state }} 
				  {{ Workorder.Customer.Contact.Addresses.ContactAddress.zip }}
				</p>
				<p id="customerCompany">{{ Workorder.Customer.company }}
				{% for ContactPhone in Workorder.Customer.Contact.Phones.ContactPhone %}
					<p data-automation="customerPhoneNumber">{{ ContactPhone.number }} ({{ ContactPhone.useType }})</p>
				{% endfor %}
				{% for ContactEmail in Workorder.Customer.Contact.Emails.ContactEmail %}
					<p data-automation="customerEmail">{{ ContactEmail.address }}</p>
				{% endfor %}
				{% for serializedID in Workorder.Serialized %}
					{% if hide_work_order_item == false %}
						<div class="workOrderItem" >Work Order Item:</div>
							{% if Workorder.Serialized.description|strlen > 0 %}
								{{ Workorder.Serialized.description }}
							{% elseif Workorder.Serialized.Item.description|strlen > 0 %}
								{{ Workorder.Serialized.Item.description }}
							{% endif %}
							{% if Workorder.Serialized.colorName|strlen > 0 %}
								/ {{ Workorder.Serialized.colorName }}
							{% endif %}
							{% if Workorder.Serialized.sizeName|strlen > 0 %}
								/ {{ Workorder.Serialized.sizeName }}
							{% endif %}
							{% if Workorder.Serialized.serial|strlen > 0 %}
								/ {{ Workorder.Serialized.serial }}
							{% endif %}
					{% else %}
					{% endif %}
				{% endfor %}
				<h2 id="woQuoteInfo">
				{% if hide_status == false %}
					Status: {{ Workorder.WorkorderStatus.name }}
				{% endif %}
				{% if hide_warranty == false %}
					{% if Workorder.warranty == 'true' %}
							<br />Warranty: Yes
						{% else %}
							<br />Warranty: No
						{% endif %}
						<br />
					{% else %}
					{% endif %}
				{% if hide_start_and_date == false %}
					Started: {{Workorder.timeIn|correcttimezone|date ("m/d/y h:i a")}}<br />
					Due on: {{Workorder.etaOut|correcttimezone|date ("m/d/y h:i a")}}<br />
					{% else %}
				{% endif %}
				{% if hide_employee == false %}
					Employee: {{ Workorder.Employee.firstName }} {{ Workorder.Employee.lastName }}
				{% else %}
				{% endif %}
				</h2>
			</div>

			<table class="lines">
				{% set servicerate = Workorder.Shop.serviceRate %}
				{% set specialorder = false %} <!-- Needed to trigger special order table if special order item is found -->
				<tr>
					<th class="description">Item/Labor</th>
					<th class="quantity">#</th>
					<th class="amount">Price</th>
				</tr>
				{% for WorkorderItem in Workorder.WorkorderItems.WorkorderItem %}
				{% if WorkorderItem.itemFeeID == 0 %}
					{% if WorkorderItem.isSpecialOrder == 'false' %}
						{{ _self.line(WorkorderItem, parameters, _context) }}
					{% else %}
						{% set specialorder = true %}
					{% endif %}
				{% endif %}
				{% endfor %}

				{% for WorkorderLine in Workorder.WorkorderLines.WorkorderLine %} <!--this loop is necessary for showing labor charges -->
					{{ _self.line(WorkorderLine, parameters, _context) }}
				{% endfor %}

				{% if specialorder == true %}
					<tr>
						<th class="specialorder">Special Orders</th>
						<th></th>
						<th></th>
					</tr>
					{% for WorkorderItem in Workorder.WorkorderItems.WorkorderItem %}
						{% if WorkorderItem.isSpecialOrder == 'true' %}
							{{ _self.line(WorkorderItem, parameters, _context) }}
						{% endif %}
					{% endfor %}
				{% endif %}
			</table>

			<table class="totals">
				<tbody>
					<tr>
						<td>Labor</td>
						<td id="totalsLaborValue" class="amount">
							{{Workorder.MetaData.labor|money}}
						</td>
					</tr>

					<tr>
						<td>Parts</td>
						<td id="totalsPartsValue" class="amount">
							{{Workorder.MetaData.parts|money}}
						</td>
					</tr>

					{% if Workorder.MetaData.discount > 0 %}
						<tr>
							<td>Discounts</td>
							<td id="totalsDiscountsValue" class="amount">
								{{Workorder.MetaData.discount|getinverse|money}}
							</td>
						</tr>
					{% endif %}

					{% if Workorder.MetaData.itemFeesSubtotal %}
						<tr>
							<td>Fee total</td>
							<td id="totalsFeesValue" class="amount">
								{{Workorder.MetaData.itemFeesSubtotal|money}}
							</td>
						</tr>
					{% endif %}

					<tr>
						<td>Tax</td>
						<td id="totalsTaxValue" class="amount">
							{{Workorder.MetaData.tax|money}}
						</td>
					</tr>

					<tr class="total">
						<td>Total</td>
						<td id="totalsTotalValue" class="amount">
							{{Workorder.MetaData.total|money}}
						</td>
					</tr>
				</tbody>
			</table>

			{% if notes_on_tag_only == false %}
				{% if Workorder.note|strlen > 0 %}
					<div class="notes">
						<h3>Notes:</h3>
						{{ Workorder.note|noteformat|raw }}
					</div>
				{% endif %}
			{% else %}
				{% if Workorder.note|strlen > 0 and parameters.type == 'shop-tag' %}
					<div class="notes">
						<h3>Notes:</h3>
						{{ Workorder.note|noteformat|raw }}
					</div>
				{% endif %}
			{% endif %}

			{% if parameters.type == 'shop-tag' %}
				{% if Workorder.internalNote|strlen > 0 %}
					<div class="notes">
						<h3>Internal Notes:</h3>
						{{ Workorder.internalNote|noteformat|raw }}
					</div>
				{% endif %}
			{% endif %}

			{% if hide_barcode == false %}
				{% if hide_barcode_sku == true %}
           			{% set hide_text = 1 %}
        		{% else %}
           			{% set hide_text = 0 %}
        		{% endif %}
				<img id="barcodeImage" height="50" width="250" class="barcode" src="/barcode.php?type=receipt&number={{Workorder.systemSku}}&hide_text={{ hide_text }}">
			{% endif %}
			{% if hide_Work_Order_Agreement == false %}
				{% if parameters.type == 'invoice' %}
					{% if Workorder.Shop.ReceiptSetup.workorderAgree|strlen > 0 %}
						<div id="signatureSection" style="padding: 10px 0px">
							<p class="workorderAgree">{{ Workorder.Shop.ReceiptSetup.workorderAgree|noteformat|raw }}</p>
							X_______________________________
							<br/>
							{{ Workorder.Customer.firstName}} {{ Workorder.Customer.lastName}}
						</div>
					{% endif %}
				{% endif %}
			{% endif %}
		</div>
	{% endfor %}

{% endblock content %}


{% macro date(Workorder) %}
    <p>
        {{"now"|correcttimezone|date('m/d/Y h:i:s A')}}
    </p>
{% endmacro %}

{% macro line(Line,parameters,options) %}
	<tr data-automation="lineItemRow">
		<td data-automation="lineItemRowItemLabor" class="description">
			{{ _self.lineDescription(Line,options) }}
			{% if Line.Discount %}
				<small>Discount: '{{ Line.Discount.name }}' (-{{ Line.SaleLine.calcLineDiscount|money }})</small>
			{% endif %}
		</td>
		{% if options.per_line_subtotal == true %}
			{% if options.itemized_hours_labor == true %}
				{% if Line.unitPriceOverride > 0 %}
					<td data-automation="lineItemQuantity" class="quantity">{{Line.unitQuantity}} x {{ Line.unitPriceOverride|money }}</td>
				{% elseif Line.hours > 0 or Line.minutes > 0 %}
					<td data-automation="lineItemQuantity" class="quantity">{{ Line.hours }} hrs {{ Line.minutes }} mins x {{ options.servicerate|money }}/hr.</td>
				{% elseif Line.unitPrice > 0 %}
					<td data-automation="lineItemQuantity" class="quantity">{{Line.unitQuantity}} x {{ Line.unitPrice|money }}</td>
				{% endif %}
			{% else %}
				{% if Line.unitPriceOverride > 0 %}
					<td data-automation="lineItemQuantity" class="quantity">{{Line.unitQuantity}} x {{ Line.unitPriceOverride|money }}</td>
				{% elseif Line.unitPrice > 0 %}
					<td data-automation="lineItemQuantity" class="quantity">{{Line.unitQuantity}} x {{ Line.unitPrice|money }}</td>
				{% endif %}
			{% endif %}
		{% elseif options.itemized_hours_labor == true and Line.unitPriceOverride == '0'%}
			{% if Line.hours > 0 or Line.minutes > 0 %}
				<td data-automation="lineItemQuantity" class="quantity">{{ Line.hours }} hrs {{ Line.minutes }} mins</td>
			{% else %}
				<td data-automation="lineItemQuantity" class="quantity">{{Line.unitQuantity}}</td>
			{% endif %}
		{% else %}
			<td data-automation="lineItemQuantity" class="quantity">{{Line.unitQuantity}}</td>
		{% endif %}
		<td data-automation="lineItemRowCharge" class="amount">
			{% if Line.warranty == 'false' %}
			    {{Line.SaleLine.displayableSubtotal|money}}
			{% elseif Line.warranty == 'true' %}
			    $0.00
			{% endif %}
		</td>
	</tr>
	{% for WorkorderSaleLine in Line.SaleLine %}
		{% if WorkorderSaleLine.itemFeeID != 0 and (WorkorderSaleLine.lineType == 'item_fee' or WorkorderSaleLine.lineType == 'item_fee_refund') %}
			<tr data-automation="lineItemRow">
				<td data-automation="lineItemRowItemFee" class="item_fee_line_name">
					<div>
					{% autoescape true %}{{ WorkorderSaleLine.ItemFee.name|nl2br }}{% endautoescape %}
					</div>
				</td>
				<td data-automation="lineItemFeeQuantity" class="quantity">{{ WorkorderSaleLine.unitQuantity }}</td>
				<td data-automation="lineItemFeeRowCharge" class="amount">{{ WorkorderSaleLine.ItemFee.feeValue|money }}</td>
			</tr>
		{% endif %}
	{% endfor %}
{% endmacro %}

{% macro lineDescription(Line,options) %}
	{% if Line.itemID != 0 %}
		<div data-automation="lineItemRowDescription" class='line_description'>
			{% autoescape true %}{{ Line.Item.description|nl2br }}{% endautoescape %}
		</div>
		{% if Line.note|strlen > 0 %}
			<div data-automation="lineItemRowNote" class='line_note'>
				{% autoescape true %}{{ Line.note|noteformat|raw }}{% endautoescape %}
			</div>
		{% endif %}
		{% if Line.isSpecialOrder == 'true' %}
			<div data-automation="lineItemRowEmployeeName" class='line_note'>
				Employee: {{ Line.Employee.firstName }} {{ Line.Employee.lastName }}
			</div>
		{% endif %}
	{% else %}
		<div data-automation="lineItemRowNote" class='line_description'>
			{% autoescape true %}{{ Line.note|noteformat|raw }}{% endautoescape %}
			{% if options.employee_name_on_labor_charges == true %}
				<div data-automation="lineItemRowEmployeeName" class='line_note'>
					Employee: {{ Line.Employee.firstName }} {{ Line.Employee.lastName }}
				</div>
			{% endif %}
		</div>
	{% endif %}
{% endmacro %}
