{% extends parameters.print ? "printbase" : "base" %}
{% block style %}
<link href="/assets/css/labels.css" media="all" rel="stylesheet" type="text/css" />
{% endblock %}
{% block content %}
	<div class="labels">
	{% for Label in Labels %}
		{% for copy in 1..Label.copies %}
			<div class="label size{{Label.MetaData.size}}{%if Label.MetaData.title == 'none'%} notitle{%endif%}">
				<article>
					<h1>{{ Label.MetaData.title }}</h1>
					<div class="text-wrapper">
						{% if Label.MetaData.price > 0 %}
						<div class="price">
							<p class="saleprice">{{ Label.MetaData.price|money|htmlparsemoney|raw }}</p>
							{% if Label.MetaData.msrp %}
							<p class="msrp">MSRP {{ Label.MetaData.msrp|money }}</p>
							{% endif %}
						</div>
						{% endif %}
						<p class="description">{{ Label.Item.description|strreplace('_',' ') }}</p>
					</div>
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
