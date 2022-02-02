{% extends parameters.print ? "printbase" : "base" %}
{% block extrastyles %}

<!-- default -->

@page { margin: 0px; }
body{
    margin: 0px;
}
.pagebreak {
    page-break-after: always;
}

.workorder {
    margin: 0px;
    padding: 1px;
    font: normal 10pt 'Helvetica Neue',Helvetica,Arial,sans-serif;
}

.header {
    text-align: center;
    margin-bottom: 30px;
}

.header p {
    margin: 0;
}

.header h1 {
    text-align: center;
    font-size: 12pt;
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
    height: {{ Workorder.Shop.ReceiptSetup.logoHeight }};
    width: {{ Workorder.Shop.ReceiptSetup.logoWidth }}
}

.detail h2 {
    margin: 0px 0px 10px 0px;
    padding: 0px;
    font-size: 11pt;
}

.detail h3 {
    margin: 0px 0px 10px 0px;
    padding: 0px;
    font-size: 11pt;
    text-decoration: underline;
}

.detail { 
    margin-bottom: 1em;
}

.detail p {
    margin: 0;
}

table.lines, table.totals {
    width: 100%;
    border-spacing:0;
    border-collapse:collapse;
}

table.lines td {
    padding: 4px 0;
}

table.totals td {
    margin: 0px;
}
        
table.lines th {
    font-size: 10pt;
    border-bottom: 1px solid #000;
    margin-bottom: 3px;
    text-align: left;
}

table.lines td.notes {
    margin-left: 15px;
}

table td.amount {
    width: 10%;
    text-align: left;
}
        
table.totals {
    text-align: right;
    border-top: 1px solid #000;
}

table.totals tr td:first-child {
    padding-right: 10px;
}

table tr.total td {
    font-weight: bold;
}

table .description {
    font-weight: bold;
}

table p {
    font-weight: normal;
    margin: 0;
}

.notes {
    overflow: hidden;
    margin: 0 0 1em;
}

.notes h1 {
    margin: 1em 0 0;
}

img.barcode {
    display: block;
    margin: 2em auto;
}

{% endblock extrastyles %}


{% block content %}
    <!-- replace.email_custom_header_msg -->
    {% for Workorder in Workorders %}
        <div class="workorder {% if not loop.last %} pagebreak{% endif %}">
            
            <div class="header">
                {% if parameters.type == 'invoice' %}
                    {% if Workorder.Shop.ReceiptSetup.hasLogo == "true" %}
                        <img class="header" src="{{ Workorder.Shop.ReceiptSetup.logo }}" height="{{ Workorder.Shop.ReceiptSetup.logoHeight }}" width="{{ Workorder.Shop.ReceiptSetup.logoWidth }}">
                    {% else %}
                    <h3>{{ Workorder.Shop.name }}</h3>
                    {% endif %}
                    {% if Workorder.Shop.ReceiptSetup.header|strlen > 0 %}
                        {{ Workorder.Shop.ReceiptSetup.header|nl2br|raw }}
                    {% else %}
                        <p>{{ Workorder.Shop.Contact.Addresses.ContactAddress.address1 }}</p>
                        <p>{{ Workorder.Shop.Contact.Addresses.ContactAddress.city }},&nbsp;{{ Workorder.Shop.Contact.Addresses.ContactAddress.state }}&nbsp;{{ Workorder.Shop.Contact.Addresses.ContactAddress.zip }}</p>
                        <p>{{ Workorder.Shop.Contact.Phones.ContactPhone.number }}</p>
                    {% endif %}
                {% endif %}
                <h1>Work Order</h1>
                <br>
                <h1><strong>#{{ Workorder.workorderID }}</strong></h1>
                {% if parameters.type == 'shop-tag' %}
                    {% if Workorder.hookIn|strlen > 0 or Workorder.hookOut|strlen > 0 %}
                        <h1 style="margin-top:20px;">Hook In: {{Workorder.hookIn}} <br />
                        Hook Out: {{Workorder.hookOut}}</h1>
                    {% endif %}
                {% endif %}
            </div>
            
            <div class="detail">
                <h3>Customer:</h3>
                <p>{{ Workorder.Customer.firstName}}&nbsp;{{ Workorder.Customer.lastName}}</p>
                <p>{{ Workorder.Customer.Contact.Addresses.ContactAddress.address1 }}</p>
                <p>{{ Workorder.Customer.Contact.Addresses.ContactAddress.address2 }}</p>
								<p>
                  {{ Workorder.Customer.Contact.Addresses.ContactAddress.city }}{% if Workorder.Customer.Contact.Addresses.ContactAddress.city and (Workorder.Customer.Contact.Addresses.ContactAddress.state or Workorder.Customer.Contact.Addresses.ContactAddress.zip) %},{% endif %}&nbsp;
                  {{ Workorder.Customer.Contact.Addresses.ContactAddress.state }}&nbsp;
                  {{ Workorder.Customer.Contact.Addresses.ContactAddress.zip }}
                </p>
                {% for ContactPhone in Workorder.Customer.Contact.Phones.ContactPhone %}
                    <p>{{ ContactPhone.number }} ({{ ContactPhone.useType }})</p>
                {% endfor %}
                {% for ContactEmail in Workorder.Customer.Contact.Emails.ContactEmail %}
                    <p>{{ ContactEmail.address }}</p>
                {% endfor %}
                <br />
                {% for serializedID in Workorder.Serialized %}
                    <h3>Work Order Item:</h3>
                        <p>{% if Workorder.Serialized.description|strlen > 0 %}
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
                        {% endif %}</p>
                    <br />
                {% endfor %}
                <h2>Started:&nbsp;{{Workorder.timeIn|correcttimezone|date ("m/d/y h:i a")}}<br />
                Due on:&nbsp;{{Workorder.etaOut|correcttimezone|date ("m/d/y h:i a")}}</h2>
            </div>

            <table class="lines">
                <tr>
                    <th>Item/Labor</th>
                    <th>Notes</th>
										<th>Charge</th>
                </tr>
                {% for WorkorderItem in Workorder.WorkorderItems.WorkorderItem %}
                <tr>
                    {% if WorkorderLine.itemID != 0 %}
                        <td class="description">
                        </td>
                    {% else %}
                        <td class="description">
                            {% if WorkorderItem.unitQuantity > 0 %}
                                {{ WorkorderItem.unitQuantity }} &times;
                            {% endif %}
                            {{ WorkorderItem.Item.description }}
                            {% if WorkorderItem.Discount %}
                                <p>Discount: {{ WorkorderItem.Discount.name }} (-{{ WorkorderItem.SaleLine.calcLineDiscount|money }})</p>
                            {% endif %}
                         </td>
                    {% endif %}
                
                        <td class="notes">
                            {{ WorkorderItem.note }}
                        </td>

                        {% if WorkorderItem.warranty == 'true' %}
                            <td class="amount"> $0.00
                        {% endif %}
                    
                        {% if WorkorderItem.warranty == 'false' %}
                            <td class="amount">        
                                {{ WorkorderItem.SaleLine.calcSubtotal|money }}
                            </td>
                        {% endif %}
                    </tr>
                {% endfor %}
                
                {% for WorkorderLine in Workorder.WorkorderLines.WorkorderLine %} <!--this loop is necessary for showing labor charges -->
                    <tr>
                        {% if WorkorderLine.itemID != 0 %}
                            <td class="description">
                                {{ WorkorderLine.Item.description }}
                                {% if WorkorderLine.Discount %}
                                    <br />
                                    <p>Discount:&nbsp;{{ WorkorderLine.Discount.name }} (-{{ WorkorderLine.SaleLine.calcLineDiscount|money }})</p>
                                {% endif %}
                             </td>
                             <td class="notes">
                                 {{ WorkorderLine.note }}
                             </td>
                        {% else %}
                            <td class="notes" colspan="2">
                            {{ WorkorderLine.note }}
                                {% if WorkorderLine.Discount %}
                                    <br />
                                    Discount:&nbsp;{{ WorkorderLine.Discount.name }} (-{{ WorkorderLine.SaleLine.calcLineDiscount|money }})
                                {% endif %}
                            </td>
                        {% endif %}
                        
                        <td class="amount">
                            {{ WorkorderLine.SaleLine.calcSubtotal|money }}
                        </td>
                    </tr>
                {% endfor %}
            </table>
            
            <table class="totals">
                <tbody>
                    <tr>
                        <td>Labor</td>
                        <td class="amount">
                            {{Workorder.MetaData.labor|money}}
                        </td>
                    </tr>
                    
                    <tr>
                        <td>Parts</td>
                        <td class="amount">
                            {{Workorder.MetaData.parts|money}}
                        </td>
                    </tr>
                
                    {% if Workorder.MetaData.discount > 0 %}
                        <tr>
                            <td>Discounts</td>
                            <td class="amount">
                                -{{Workorder.MetaData.discount|money}}
                            </td>
                        </tr>
                    {% endif %}
                
                    <tr>
                        <td>Tax</td>
                        <td class="amount">
                            {{Workorder.MetaData.tax|money}}
                        </td>
                    </tr>
                
                    <tr class="total">
                        <td>Total</td>
                        <td class="amount">
                            {{Workorder.MetaData.total|money}}
                        </td>
                    </tr>
                </tbody>
            </table>

            {% if Workorder.note|strlen > 0 %}
                <div class="notes">
                    <h3>Notes:</h3>
                    {{ Workorder.note|noteformat|raw }}
                </div>
            {% endif %}

            {% if parameters.type == 'shop-tag' %}
                {% if Workorder.internalNote|strlen > 0 %}
                    <div class="notes">
                        <h3>Internal Notes:</h3>
                        {{ Workorder.internalNote|noteformat|raw }}
                    </div>
                {% endif %}
            {% endif %}

            <img height="50" width="250" class="barcode" src="/barcode.php?type=receipt&number={{Workorder.systemSku}}">
            
            {% if parameters.type == 'invoice' %}
                {% if Workorder.Shop.ReceiptSetup.workorderAgree|strlen > 0 %}
                    <div style="padding: 10px 0px">
                        <p style="margin-bottom:40px;">{{ Workorder.Shop.ReceiptSetup.workorderAgree|noteformat|raw }}</p>
                        X_______________________________
                        <br/>
                        {{ Workorder.Customer.firstName}}&nbsp;{{ Workorder.Customer.lastName}}
                    </div>
            </div>


            {% endif %}
        {% endif %}
    
    {% endfor %}

{% endblock content %}
