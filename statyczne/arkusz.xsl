<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="strona">
		<html lang="pl">
			<head>
				<meta charset="UTF-8" />
				<meta http-equiv="X-UA-Compatible" content="IE=edge" />
				<meta name="viewport" content="width=device-width, initial-scale=1.0" />
				<title>
					<xsl:value-of select="dane_pwp/tytul" />
				</title>
				<style>
div {
	margin: 1em;
	padding: 1em;
	border: 2px solid green;
	background-color: #8f8;
	border-radius: 0.5em;
}
				</style>
			</head>
			<body>
				<h1>
					<xsl:value-of select="dane_pwp/tytul" />
				</h1>
				<xsl:apply-templates />
			</body>
		</html>
	</xsl:template>
	<xsl:template match="dane_pwp" />
	<xsl:template match="pytanie">
		<div>
			<b><xsl:value-of select="kto" />: </b>
			<xsl:value-of select="pytanie" />
			<br/>
			<b><xsl:value-of select="komu" />: </b>
			<xsl:value-of select="odpowiedz" />
		</div>
	</xsl:template>
</xsl:stylesheet>