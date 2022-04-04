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
			</head>
			<body>
				<xsl:apply-templates />
			</body>
		</html>
	</xsl:template>
	<xsl:template match="dane_pwp" />
</xsl:stylesheet>