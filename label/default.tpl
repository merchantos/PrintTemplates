{% extends parameters.print ? "printbase" : "base" %}
{% block content %}
	{% for Label in Labels %}
		<div style="{% if not loop.last %}page-break-after: always; {% endif %}margin: 0px; padding 5px; position: relative; width: 200px; height: 100px; overflow: hidden;">
			<div style="text-align: center; font-size: 12px; text-decoration: underline; position: relative; width: 200px; height: 18px;">{{ Shop.name }}</div>
			<div style="position: relative; bottom: 3px; width: 200px; height: 42px; overflow: hidden;">
				<div style="float: left; text-align: center; margin-right: 3px; position: relative; height: 26px;">
					<span style="font-size: 26px; font-weight: bold;">{% for Price in Label.Item.Prices %}{% if Price.ItemPrice.useType == "Default" %}{{ Price.ItemPrice.amount|formatValueToString('money') }}{% endif %}{% endfor %}</span>
				</div>
				<span style="font-size: 12px; font-weight: bold; position: relative; z-index: 2; height: 42px;">{{ Label.Item.description }}</span>
			</div>
			<div style="text-align: center; clear: both; position: relative; width: 200px; height: 40px; overflow: hidden;">
				<img height="40" width="200" src="/barcode.php?type=label&number={{ Label.Item.systemSku }}&noframe=1">
		
			</div>
		</div>
	{% endfor %}
{% endblock content %}
