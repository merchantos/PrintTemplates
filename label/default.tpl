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
			font-size: 8px;
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
			text-align: right;
			clear: both;
			position: relative;
			height: 24px;
			width: 55px;
			margin-top: 1px;
			padding: 0px;
			overflow: hidden;
		}
		.label .barcode img
		{
			position: relative;
			right: 16px;
		}
		.label .color
		{
			font-size: 8px;
			text-align: left;
			position: relative;
		}
		.label .size
		{
			font-size: 8px;
			text-align: right;
			position: relative;
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
			height: 110px;
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
			font-size: 8px; 
			font-weight: bold;
			margin-top: -5px;
			margin-bottom: -5px;
		}
		.label .price .msrp
		{
			clear: both;
			font-size: 8px;
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
			text-align: right;
			clear: both;
			position: relative;
			width: 100px;
			height: 20px;
			overflow: hidden;
		}
		.label .color
		{
			font-size: 8px;
			text-align: left;
			position: relative;
		}
		.label .size
		{
			font-size: 8px;
			text-align: right;
			position: relative;
		}
	{% endif %}
{% endblock extrastyles %}
{% block content %}
	{% for Label in Labels %}
		{% set lastlabel = loop.last %}
		{% for copy in 1..Label.copies %}
				<div class="label{% if not lastlabel %}{% if not loop.last %} pagebreak{% endif %}{% endif %}">
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
						<div class="description">{{ Label.Item.description }}</div>
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
