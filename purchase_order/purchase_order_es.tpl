{#
***Begin Custom Options***
Set any of the options in this section from 'false' to 'true' in order to enable them in the template
#}
{% set hide_rep_info = false %} {# Removes acct rep from PO template #}
{% set hide_account_number = false %} {# Removes acct number from PO template #}
{% set hide_shipping_table = false %} {# Removes shipping table from PO template #}
{% set hide_shipping_notes = false %} {# Removes shipping notes from PO template #}
{% set hide_general_notes = false %} {# Removes general notes from PO template #}
{#
***End Custom Options***
#}
{% extends parameters.print ? "printbase" : "base" %}
{% block style %}

<link href="/assets/css/labels.css" media="all" rel="stylesheet" type="text/css" />
<style type="text/css">
  header {
    display: block
  }

  html {
    font-family: sans-serif;
    -webkit-text-size-adjust: 100%;
    -ms-text-size-adjust: 100%;
  }

  body {
    margin: 30px;
  }

  b,
  strong {
    font-weight: bold;
  }

  small {
    font-size: 80%;
  }

  table {
    border-collapse: collapse;
    border-spacing: 0;
  }

  * {
    box-sizing: border-box
  }

  @media print {

    html,
    body {
      font-size: 75%;
    }
  }

  @media screen {

    .document html,
    body {
      margin: 1rem;
    }
  }

  body {
    font-family: "Open Sans", Helvetica, Arial, Verdana, sans-serif
  }

  h2,
  h3,
  h4,
  h5,
  h6 {
    font-weight: 400;
    color: #000;
    margin: .5em 0 .5em;
  }

  h3,
  h4,
  h5,
  h6 {
    font-weight: 600;
  }

  h2 small {
    font-weight: 400;
    color: #666;
  }

  h5,
  h6 {
    color: #444;
  }

  h2 {
    font-size: 2rem;
  }

  h3 {
    font-size: 1.5rem;
  }

  h4 {
    font-size: 1.25rem;
  }

  h5 {
    font-size: 1rem;
  }

  h6 {
    font-size: .875rem;
    text-transform: uppercase;
  }

  p {
    font-size: 1rem
  }

  p.xs {
    font-size: .75rem
  }

  p.s {
    font-size: .875rem;
  }

  .row {
    overflow: hidden;
  }

  @media (min-width: 480px) {
    .col-md-6 {
      width: 50%;
    }
  }

  @media (min-width: 480px) {
    .col-md-6 {
      float: left;
    }

    .col-spacerL-md6 {
      margin-left: 50%;
    }
  }

  table {
    background: transparent;
  }

  table.document {
    width: 100%;
  }

  table.document td,
  table.document th {
    padding: .375rem;
    vertical-align: top;
  }

  table.document th {
    text-align: left;
    text-transform: uppercase;
  }

  table.document td.money {
    text-align: right;
  }

  table.document td.money:before {
    margin-right: .125rem;
  }

  table.document thead {
    border-bottom: 1px solid #666;
    border-top: 1px solid #666;
  }

  table.document thead th {
    padding-top: .25rem;
    padding-bottom: .25rem;
    font-size: .75rem;
    background-color: #f8f8f8;
    line-height: 1.5;
  }

  table.document tbody td {
    border: 1px solid #666;
  }

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

  * {
    box-sizing: border-box
  }

  .startStop {
    font-size: .75rem;
  }

  .line_note {
    font-size: .65rem;
  }

  .u-margin-An {
    margin: 0
  }

  .u-margin-Tn {
    margin-top: 0;
  }

  .u-margin-Bxl {
    margin-bottom: 30px
  }

  .u-margin-Vn {
    margin-top: 0;
    margin-bottom: 0;
  }

  .u-margin-Vxxs {
    margin-top: 4px;
    margin-bottom: 4px;
    display: block;
  }

  img.barcode {
    margin: 0px auto;
    display: block;
  }

  html {
    height: 100%
  }
</style>
{% endblock style %}
{% block content %}
{% for Order in Orders %}
<header class="col-spacerL-md6 col-md6 u-margin-Bxl">
  <h2 class="u-margin-Vn">
    Pedido de compra<small> #{{ Order.orderID }}</small>
  </h2>
  <div class="startStop">
    Fecha de pedido {{Order.orderedDate|correcttimezone|date ("m/d/y")}}<br />
    Fecha de entrega estimada {{Order.arrivalDate|correcttimezone|date ("m/d/y")}}<br />
  </div>
</header>
<div class="row">
  <div class="col-md-6">
    <h6 class="u-margin-Vn">Proveedor</h6>
    <h4 class="u-margin-Vxxs">{{ Order.Vendor.name}}</h4>
    {% if hide_rep_info == false %}
    {% if Order.Vendor.Reps.VendorRep.firstName|strlen > 0 %}
    <h6>A/A {{Order.Vendor.Reps.VendorRep.firstName}} {{Order.Vendor.Reps.VendorRep.lastName}}</h6>
    {% endif %}
    {% endif %}
    {% if hide_account_number == false %}
    {% if Order.Vendor.accountNumber > 0 %}
    <h6>Cuenta #{{Order.Vendor.accountNumber}}</h6>
    {% endif %}
    {% endif %}
    <p class="u-margin-Tn s">
      {{ Order.Vendor.Contact.Addresses.ContactAddress.address1 }}
      {% if Order.Vendor.Contact.Addresses.ContactAddress.address2|strlen > 0 %}
      <br>{{ Order.Vendor.Contact.Addresses.ContactAddress.address2 }}
      {% endif %}
      {% if Order.Vendor.Contact.Addresses.ContactAddress.city|strlen > 0 %}
      <br>{{ Order.Vendor.Contact.Addresses.ContactAddress.city }},
      {{ Order.Vendor.Contact.Addresses.ContactAddress.state }} {{ Order.Vendor.Contact.Addresses.ContactAddress.zip }}
      {% endif %}
      {% for ContactPhone in Order.Vendor.Contact.Phones.ContactPhone %}
      <br>{{ ContactPhone.number }} {{ ContactPhone.useType }}
      {% endfor %}
      {% for ContactEmail in Order.Vendor.Contact.Emails.ContactEmail %}
      <br>{{ ContactEmail.address }}
      {% endfor %}
    </p>
  </div>
  <div class="row">
    <h6 class="u-margin-Vn">Enviar a</h6>
    <h4 class="u-margin-Vxxs">{{ Order.Shop.name }}</h4>
    <p class="u-margin-Tn s">
      {{ Order.Shop.Contact.Addresses.ContactAddress.address1 }}
      <br>{{ Order.Shop.Contact.Addresses.ContactAddress.city }},
      {{ Order.Shop.Contact.Addresses.ContactAddress.state }} {{ Order.Shop.Contact.Addresses.ContactAddress.zip }}
      <br>{{ Order.Shop.Contact.Phones.ContactPhone.number }}
    </p>
  </div>
</div>
{% if hide_shipping_table == false %}
<h3>Información de envío</h3>
<table class="document">
  <thead>
    <tr>
      <th>Envío</th>
      <th>Cantidad total</th>
      {% if Order.MetaData.totalDiscount > 0 %}
      <th>Descuento</th>
      {% endif %}
      <th>Otro</th>
    </tr>
  </thead>
  <tr>
    <td>
      {% if Order.MetaData.shipping|strlen > 0 %}
      {{Order.MetaData.shipping|format_currency}}
      {% else %}
      <i>Ninguno</i>
      {% endif %}
    </td>
    <td>
      {% if Order.totalQuantity|strlen > 0 %}
      {{Order.totalQuantity}}
      {% else %}
      <i>Ninguno</i>
      {% endif %}
    </td>
    {% if Order.MetaData.totalDiscount > 0 %}
    <td>{{Order.discount|floatval * 100}}%</td>
    {% endif %}
    <td>
      {% if Order.MetaData.other|strlen > 0 %}
      {{Order.MetaData.other|format_currency}}
      {% else %}
      <i>Ninguno</i>
      {% endif %}
    </td>
  </tr>
</table>
<br>
<table>
  {% if hide_shipping_notes == false %}
  {% if Order.shipInstructions|strlen > 0 %}
  <tr class="minor leading-row-gap">
    <th>Notas del envío:</th>
    <td>{{Order.shipInstructions}}</td>
    <td></td>
  </tr>
  {% endif %}
  {% endif %}
</table>
{% endif %}
<h3>Detalles</h3>
<table class="document">
  <thead>
    <tr>
      <th>ID del proveedor</th>
      <th>Código UPC</th>
      <th>Descripción</th>
      <th>Cant.</th>
      <th>Costo unitario</th>
      {% if Order.discount > 0 %}
      <th>Monto con descuento</th>
      {% else %}
      <th>Monto</th>
      {% endif %}
    </tr>
  </thead>
  {% for OrderLine in Order.OrderLines.OrderLine %}
  <tr>
    <td>
      {% for ItemVendorNum in OrderLine.Item.ItemVendorNums.ItemVendorNum %}
      {% if (Order.vendorID|number_format) == (ItemVendorNum.vendorID|number_format) %}
      {{ ItemVendorNum.value }}
      {% endif %}
      {% endfor %}
    </td>
    <td>{{OrderLine.Item.upc}}</td>
    <td>{{OrderLine.Item.description}}</td>
    <td>{{OrderLine.quantity}}</td>
    <td class="money">{{OrderLine.MetaData.cost|format_currency}}</td>
    <td class="money">{{OrderLine.MetaData.total|format_currency}}</td>
  </tr>
  {% endfor %}
  <tfoot>
    <tr class="minor">
      <th>Subtotal</th>
      {% if Order.MetaData.subtotal > 0 %}
      <th></th>
      {% endif %}
      <td></td>
      <td></td>
      <td class="money">{{Order.MetaData.subtotal|format_currency}}</td>
    </tr>
    {% if Order.MetaData.totalDiscount > 0 %}
    <tr class="minor">
      <th>Descuento</th>
      <th></th>
      <td></td>
      <td></td>
      <td class="money">{{Order.MetaData.totalDiscount|format_currency({invert: true})}}</td>
    </tr>
    {% endif %}
    <tr class="total">
      <th>Total</th>
      {% if Order.MetaData.total > 0 %}
      <th></th>
      {% endif %}
      <td></td>
      <td></td>
      <td class="money">{{Order.MetaData.total|format_currency}}</td>
    </tr>
  </tfoot>
</table>
<br>
{% if hide_general_notes == false %}
{% if Order.Note.note|strlen > 0 %}
<h3>Notas:</h3>
<br>{{Order.Note.note|nl2br|raw}}
{% endif %}
{% endif %}
{% endfor %}
{% endblock content %}
