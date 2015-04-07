{#
                            ***Begin Custom Options***
Set any of the options in this section from 'false' to 'true' in order to enable them in the template
#}

{% set vendor_number = false %}                     {# Display Vendor ID (if available) above Description #}
{% set show_custom_sku = false %}                   {# Display Custom SKU (if available) above Description #}
{% set show_manufacturer_sku = false %}             {# Display Manufacturer SKU (if available) above Description #}
{% set show_upc_code = false %}                     {# Display the UPC code at the top of the receipt (using UPC codes in barcode does not work) #}
{% set show_date = false %}                         {# Display today's date above description (ddmmyy formatting) #}
{% set price_with_no_cents = false %}               {# Remove cents from being displayed in price #}
{% set date_format = 'mdy' %}                       {# Format the date is shown in if show_date is enabled.
                                                        m = 2 digit month, d = 2 digit day, y = 2 digit year, Y = 4 digit year #}
{% set hide_price = false %}                        {# Remove the price from displaying on label #}
{% set hide_description = false %}                  {# Remove the description from displaying on label #}
{% set hide_barcode = false %}                      {# Remove the barcode from displaying on label #}

{# Use the following if adjustments to the label position are needed. Positive and negative numbers work #}

{% set top_margin = '0px' %}
{% set right_margin = '0px' %}
{% set bottom_margin = '0px' %}
{% set left_margin = '0px' %}

{# Enter Category IDs (found in Settings > Categories to the left of Category names) into the appropriate section, separated by commas and enclosed in single quotes #}

{% set normal_label_categories =  [''] %}
{% set alt_label_categories = [''] %}
{% set small_label_categories = [''] %}
{% set jewelry_label_categories = [''] %}


{# Normal Label (2.25x1.25) settings #}

{% set normal_description_font_size = '9pt' %}      {# Default is 9pt #}
{% set normal_price_font_size = '12pt' %}           {# Default is 12pt #}

{# For Vertical:   Negative numbers move up, positive move down
   For Horizontal: Negative numbers move right, positive move left #}

{% set normal_barcode_vertical = '0px' %}
{% set normal_barcode_horizontal = '0px' %}


{# Alt. Label (2.00x1.00) settings #}

{% set alt_description_font_size = '9pt' %}         {# Default is 9pt #}
{% set alt_price_font_size = '12pt' %}              {# Default is 12pt #}

{# For Vertical:   Negative numbers move up, positive move down
   For Horizontal: Negative numbers move right, positive move left #}

{% set alt_barcode_vertical = '0px' %}
{% set alt_barcode_horizontal = '0px' %}


{# Small Label (1.25x1.00) settings #}

{% set small_description_font_size = '9pt' %}       {# Default is 9pt #}
{% set small_price_font_size = '7pt' %}             {# Default is 7pt #}

{# For Vertical:   Negative numbers move up, positive move down
   For Horizontal: Negative numbers move right, positive move left #}

{% set small_barcode_vertical = '0px' %}
{% set small_barcode_horizontal = '0px' %}


{# Jewelry Label (2.20x.50) settings  #}

{% set jewelry_description_font_size = '7.5pt' %}   {# Default is 7.5pt #}
{% set jewelry_price_font_size = '6pt' %}           {# Default is 6pt #}

{# For Vertical:   Negative numbers move up, positive move down
   For Horizontal: Negative numbers move right, positive move left #}

{% set jewelry_description_vertical = '0px' %}
{% set jewelry_description_horizontal = '0px' %}

{% set jewelry_price_vertical = '0px' %}
{% set jewelry_price_horizontal = '0px' %}

{% set jewelry_barcode_vertical = '0px' %}
{% set jewelry_barcode_horizontal = '0px' %}


{#
                            ***End Custom Options***
#}


{% extends parameters.print ? "printbase" : "base" %}
{% block style %}

<link href="/assets/css/labels.css" media="all" rel="stylesheet" type="text/css" />

<style type="text/css">

    body {
        margin: 0;
    }

    .custom_margin {
        margin: {{top_margin}} {{right_margin}} {{bottom_margin}} {{left_margin}};
    }

    {# Normal Label (2.25x1.25) CSS settings #}

    .label.size225x125 .description {
        font-size: {{ normal_description_font_size }};
    }

    .label.size225x125 .price {
        font-size: {{ normal_price_font_size }};
    }

    .label.size225x125 .barcode {
        position: absolute;
        bottom: {{ normal_barcode_vertical * -1 }}px;
        left: {{ normal_barcode_horizontal * -1 }}px;
    }

    {# Alt. Label (2.00x1.00) CSS settings #}

    .label.size200x100 .description {
        font-size: {{ alt_description_font_size }};
    }

    .label.size200x100 .price {
        font-size: {{ alt_price_font_size }};
    }

    .label.size200x100 .barcode {
        position: absolute;
        bottom: {{ alt_barcode_vertical * -1 }}px;
        left: {{ alt_barcode_horizontal * -1 }}px;
    }
    {# Small Label (1.25x1.00) CSS settings #}

    .label.size125x100 .description {
        font-size: {{ small_description_font_size }};
    }

    .label.size125x100 .price {
        font-size: {{ small_price_font_size }};
    }

    .label.size125x100 .barcode {
        position: absolute;
        bottom: {{ small_barcode_vertical * -1 }}px;
        left: {{ small_barcode_horizontal * -1 }}px;
    }

    {# Jewelry Label (2.20x.50) CSS settings #}

    .label.size220x50 .description {
        top: {{ jewelry_description_vertical }};
        right: {{ jewelry_description_horizontal }};
        font-size: {{ jewelry_description_font_size }}
    }

    .label.size220x50 .price {
        top: {{ jewelry_price_vertical + 25 }}px;
        right: {{ jewelry_price_horizontal }};
        font-size: {{ jewelry_price_font_size }}
    }

    .label.size220x50 .barcode {
        top: {{ jewelry_barcode_vertical }};
        left: {{ jewelry_barcode_horizontal * -1 }}px;
    }

</style>

{% endblock %}
{% block content %}
	<div class="labels">
	{% for Label in Labels %}
		{% for copy in 1..Label.copies %}
            <div class="custom_margin">
                {% set size_specified = false %}
                {% for category in normal_label_categories %}
                    {% if category == Label.Item.categoryID %}
                        <div class="label size225x125{%if Label.MetaData.title == 'none'%} notitle{%endif%}">
                        {% set size_specified = true %}
                    {% endif %}
                {% endfor %}
                {% for category in alt_label_categories %}
                    {% if category == Label.Item.categoryID %}
                        <div class="label size200x100{%if Label.MetaData.title == 'none'%} notitle{%endif%}">
                        {% set size_specified = true %}
                    {% endif %}
                {% endfor %}
                {% for category in small_label_categories %}
                    {% if category == Label.Item.categoryID %}
                        <div class="label size125x100{%if Label.MetaData.title == 'none'%} notitle{%endif%}">
                        {% set size_specified = true %}
                    {% endif %}
                {% endfor %}
                {% for category in jewelry_label_categories %}
                    {% if category == Label.Item.categoryID %}
                        <div class="label size220x50{%if Label.MetaData.title == 'none'%} notitle{%endif%}">
                        {% set size_specified = true %}
                    {% endif %}
                {% endfor %}
                {% if size_specified == false %}
                    <div class="label size{{Label.MetaData.size}}{%if Label.MetaData.title == 'none'%} notitle{%endif%}">
                {% endif %}
    				<article>
    					<h1>{{ Label.MetaData.title }}</h1>
                        {% if hide_price == false %}
        					{% if Label.MetaData.price > 0 %}
            					<div class="price">
                                    {% if price_with_no_cents == true %}
                                        <p class="saleprice"><sup class="currency">$</sup>{{ Label.MetaData.price|number_format(0, '', '')|raw }}</p>
                                    {% else %}
            						  <p class="saleprice">{{ Label.MetaData.price|money|htmlparsemoney|raw }}</p>
                                    {% endif %}
            						{% if Label.MetaData.msrp %}
            						<p class="msrp">MSRP {{ Label.MetaData.msrp|money }}</p>
            						{% endif %}
            					</div>
        					{% endif %}
                        {% endif %}
    					<p class="description">
                            {% if show_date == true %}
                                {{"now"|date(date_format)}}
                            {% endif %}
    						{% if vendor_number == true %}
    							{% for ItemVendorNum in Label.Item.ItemVendorNums.ItemVendorNum %}
    	   							{% if Label.Item.defaultVendorID+0 == ItemVendorNum.vendorID+0 %}
    	   								<span style="font-style: italic;">{{ ItemVendorNum.value }}</span>
    	   							{% endif %}
    							{% endfor %}
    						{% endif %}
                            {% if show_upc_code == true %}
                                {% if Label.Item.upc|strlen > 0 %}
                                    <i>{{ Label.Item.upc }}</i>
                                {% endif %}
                            {% endif %}
                            {% if show_custom_sku == true %}
                                {% if Label.Item.customSku|strlen > 0 %}
                                    <i>{{ Label.Item.customSku }}</i>
                                {% endif %}
                            {% endif %}
                            {% if show_manufacturer_sku == true %}
                                {% if Label.Item.manufacturerSku|strlen > 0 %}
                                    <i>{{ Label.Item.manufacturerSku }}</i>
                                {% endif %}
                            {% endif %}
                            {% if hide_description == false %}
    						  {{ Label.Item.description|strreplace('_',' ') }}
                            {% endif %}
    					</p>
    				</article>
                    {% if hide_barcode == false %}
        				<footer class="barcode">
        					<img class="ean8" src="/barcode.php?type=label&amp;number={{ Label.Item.systemSku }}&amp;ean8=1&amp;noframe=1">
        					<img class="ean" src="/barcode.php?type=label&amp;number={{ Label.Item.systemSku }}&amp;noframe=1">
        				</footer>
                    {% endif %}
    			</div>
            </div>
		{% endfor %}
	{% endfor %}
	</div>
{% endblock content %}
