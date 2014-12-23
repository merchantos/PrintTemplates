{#
                            ***Begin Custom Options***
Set any of the options in this section from 'false' to 'true' in order to enable them in the template
#}

{% set vendor_number = false %}
{% set show_custom_sku = false %}
{% set show_manufacturer_sku = false %}

{% set top_margin = '0px' %}
{% set right_margin = '0px' %}
{% set bottom_margin = '0px' %}
{% set left_margin = '0px' %}

{# Normal Label (2.25x1.25) settings #}

{% set normal_description_font_size = '9pt' %}      {# Default is 9pt #}
{% set normal_price_font_size = '12pt' %}           {# Default is 12pt #}

{# Alt. Label (2.00x1.00) settings #}

{% set alt_description_font_size = '9pt' %}         {# Default is 9pt #}
{% set alt_price_font_size = '12pt' %}              {# Default is 12pt #}

{# Small Label (1.25x1.00) settings #}

{% set small_description_font_size = '9pt' %}       {# Default is 9pt #}
{% set small_price_font_size = '7pt' %}             {# Default is 7pt #}

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
        margin: {{top_margin}} {{right_margin}} {{bottom_margin}} {{left_margin}};
    }
    
    {# Normal Label (2.25x1.25) CSS settings #}

    .label.size225x125 .description {
        font-size: {{ normal_description_font_size }};
    }

    .label.size225x125 .price {
        font-size: {{ normal_price_font_size }};
    }

    {# Alt. Label (2.00x1.00) CSS settings #}

    .label.size200x100 .description {
        font-size: {{ alt_description_font_size }};
    }

    .label.size200x100 .price {
        font-size: {{ alt_price_font_size }};
    }

    {# Small Label (1.25x1.00) CSS settings #}

    .label.size125x100 .description{
        font-size: {{ small_description_font_size }};
    }

    .label.size125x100 .price {
        font-size: {{ small_price_font_size }};
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
			<div class="label size{{Label.MetaData.size}}{%if Label.MetaData.title == 'none'%} notitle{%endif%}">
				<article>
					<h1>{{ Label.MetaData.title }}</h1>
					{% if Label.MetaData.price > 0 %}
					<div class="price">
						<p class="saleprice">{{ Label.MetaData.price|money|htmlparsemoney|raw }}</p>
						{% if Label.MetaData.msrp %}
						<p class="msrp">MSRP {{ Label.MetaData.msrp|money }}</p>
						{% endif %}
					</div>
					{% endif %}
					<p class="description">
						{% if vendor_number == true %}
							{% for ItemVendorNum in Label.Item.ItemVendorNums.ItemVendorNum %}
	   							{% if Label.Item.defaultVendorID+0 == ItemVendorNum.vendorID+0 %}
	   								<span style="font-style: italic;">{{ ItemVendorNum.value }}</span>
	   							{% endif %}
							{% endfor %}
						{% endif %}
                        {% if show_custom_sku == true %}
                            {% if Label.Item.manufacturerSku|strlen > 0 %}
                                <i>{{ Label.Item.customSku }}</i>
                            {% endif %}
                        {% endif %}
                        {% if show_manufacturer_sku == true %}
                            {% if Label.Item.manufacturerSku|strlen > 0 %}
                                <i>{{ Label.Item.manufacturerSku }}</i>
                            {% endif %}
                        {% endif %}
						{{ Label.Item.description|strreplace('_',' ') }}
					</p>
				</article>
				<footer class="barcode">
					<img class="ean8" src="/barcode.php?type=label&amp;number={{ Label.Item.systemSku }}&amp;ean8=1&amp;noframe=1">
					<img class="ean" src="/barcode.php?type=label&amp;number={{ Label.Item.systemSku }}&amp;noframe=1">
				</footer>
			</div>
		{% endfor %}
	{% endfor %}
	</div>
{% endblock content %}
