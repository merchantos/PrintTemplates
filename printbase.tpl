{% extends "base" %}

{% macro autoPrint() %}
	<script type="text/javascript">
		$(document).ready(function() {
			{% if Sales %}
				var printer_name = "receipt";
			{% elseif Labels %}
				var printer_name = "label";
			{% else %}
				var printer_name = "report";
			{% endif %}
			
			try {
				merchantos.print.print(printer_name);
				window.focus();
			} catch (e) {
				// do nothing
			}
		});
	</script>
{% endmacro %}

{% block head %}
	<head>
		<title>{% block title %}MerchantOS - Print{% endblock %}</title>
		<link rel="shortcut icon" href="/graphics/favicon.ico" type="image/vnd.microsoft.icon" />
		{% block merchantos_js_css %}
			$asset_block
		{% endblock %}
		{% block style %}
			<style type="text/css">
			* {
				font-size: 10pt;
				font-family: Arial,Helvetica,sans-serif;
			}
			@page {
				margin: 0px:
			}
			html {
				background: #FFFFFF;
			}
			body {
				margin: 0px;
				background: #FFFFFF;
				color: #000000;
			}
			{% block extrastyles %}
			{% endblock %}
			</style>
		{% endblock style %}
		{% block autoprint %}
			{% if not parameters.no_auto_print %}
				{{ _self.autoPrint() }}
			{% endif %}
		{% endblock %}
	</head>
{% endblock head %}
