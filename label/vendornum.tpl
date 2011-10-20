{% extends parameters.print ? "printbase" : "base" %}
{% block extrastyles %}
	{% if parameters.labelSize == "1.25x1.00" %}
		.pagebreak
		{
			page-break-after: always;
		}
		.label
		{
			margin: 0 0 0 5px;
			padding: 0px;
			position: relative;
			height: 90px;
			width: 110px;
			overflow: hidden;
		}
		.label .content
		{
			position: relative;
			width: 110px;
			height: 43px;
			overflow: hidden;
		}
		.label .price
		{
			font-size: 14px;
			font-weight: bold;
			float: left;
			margin-right: 4px;
			margin-bottom: -4px;
		}
		.label .description
		{
			position: relative;
			font-size: 12px;
			line-height: 14px;
			top: 3px;
		}
		.label .barcode
		{
			text-align: center;
			clear: both;
			position: relative;
			height: 47px;
			width: 110px;
			margin-top: 2px;
			padding: 0px;
			overflow: hidden;
		}
		.label .barcode img
		{
			position: relative;
			right: 16px;
		}
	{% else %}
		.pagebreak
		{
			page-break-after: always;
		}
		.label
		{
			margin: 0px;
			padding: 5px;
			position: relative;
			width: 200px;
			height: 100px;
			overflow: hidden;
		}
		.label h1
		{
			margin: 0;
			padding: 0;
			text-align: center;
			font-size: 12px;
			text-decoration: underline;
			position: relative;
			width: 200px;
			height: 18px;
		}
		.label .content
		{
			position: relative;
			margin-top: 2px;
			bottom: 3px;
			width: 200px;
			height: 45px;
			overflow: hidden;
		}
		.label .price
		{
			float: left;
			text-align: center;
			margin-right: 3px;
			position: relative;
			height: 18px;

		}
		.label .price .saleprice
		{
			font-size: 26px;
			font-weight: bold;
			margin-top: -5px;
			margin-bottom: -5px;
		}
		.label .price .msrp
		{
			clear: both;
			font-size: 10px;
		}
		.label .description
		{
			font-size: 12px;
			font-weight: bold;
			position: relative;
			z-index: 2;
			height: 52px;
			margin-top: 2px;
		}
		.label .barcode
		{
			text-align: center;
			clear: both;
			position: relative;
			width: 200px;
			height: 40px;
			overflow: hidden;
		}
	{% endif %}
{% endblock extrastyles %}
{% block content %}
	{% for Label in Labels %}
		{% set lastlabel = loop.last %}
		{% for copy in 1..Label.copies %}
				<div class="label{% if lastlabel %}{% if Label.copies==copy %}{% else %} pagebreak{% endif %}{% else %} pagebreak{% endif %}">
					{% if parameters.labelSize != "1.25x1.00" %}
						<h1>{{ Shop.name }}</h1>
					{% endif %}
					<div class="content">
						{% spaceless %}
							{% set msrp = false %}
							{% set price = false %}
							{% for ItemPrice in Label.Item.Prices.ItemPrice %}
								{% if ItemPrice.useType == "Default" %}
									{% set price = ItemPrice.amount|mosformat('money') %}
								{% endif %}
								{% if ItemPrice.useType == "MSRP" %}
									{% set msrp = ItemPrice.amount|mosformat('money') %}
								{% endif %}
							{% endfor %}
						{% endspaceless %}
						{% if Shop.labelMsrp=="true" and msrp and msrp > price %}
							<div class="price" style="height: 30px;">
								<div class="saleprice">{{ price }}</div>
								{% if parameters.labelSize != "1.25x1.00" %}
									<div class="msrp">MSRP {{ msrp }}</div>
								{% endif %}
							</div>
						{% else %}
							<div class="price"><div class="saleprice">{{ price }}</div></div>
						{% endif %}
						<div class="description">
						{% for ItemVendorNum in Label.Item.ItemVendorNums.ItemVendorNum %}
   						{% if Label.Item.defaultVendorID+0 == ItemVendorNum.vendorID+0 %}
   							<i>{{ ItemVendorNum.value }}</i>
   						{% endif %}
						{% endfor %}
						{{ Label.Item.description }}</div>
					</div>
					<div class="barcode">
						{% if parameters.labelSize == "1.25x1.00" %}
							<img height="47" width="140" src="/barcode.php?type=label&number={{ Label.Item.systemSku }}&ean8=1&noframe=1">
						{% else %}
							<img height="40" width="200" src="/barcode.php?type=label&number={{ Label.Item.systemSku }}&noframe=1">
						{% endif %}
					</div>
				</div>
		{% endfor %}
	{% endfor %}
{% endblock content %}
