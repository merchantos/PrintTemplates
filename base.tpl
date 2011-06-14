{% block start %}
	<!DOCTYPE html>
	<html>
{% endblock start %}
{% block head %}
	<head>
		{% block merchantos_js_css %}
			$asset_block
		{% endblock %}
		<title>{% block title %}{{ parameters.template }}{% endblock %}</title>
		<link rel="shortcut icon" href="/graphics/favicon.ico" type="image/vnd.microsoft.icon" />
		{% block style %}
			<style>	
			{% block extrastyles %}
			{% endblock %}
			</style>
		{% endblock style %}
	</head>
{% endblock head %}
{% block body %}
	<body>
		{% block content %}
			Content
		{% endblock %}
	</body>
{% endblock body %}
{% block end %}
	</html>
{% endblock end %}
