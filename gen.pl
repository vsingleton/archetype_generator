#!/usr/bin/perl -w

use strict;
use File::Path;
use File::Find;

my $httpdsDir = "$ENV{'HOME'}/httpds";
my $portalsDir = "$ENV{'HOME'}/Portals/liferay.com";

# set up Liferay for testing ...

my $liferay7_0Version = "7.0.0-a2";
my $liferay6_2Version = "6.2.3";

my %liferayDir = ();
$liferayDir{"$liferay6_2Version"} = "${portalsDir}/liferay-portal-${liferay6_2Version}";
$liferayDir{"$liferay7_0Version"} = "${portalsDir}/liferay-portal-${liferay7_0Version}";

# set up Pluto for testing ...
my $plutoVersion = "2.0.x";
my $plutoDir = "${portalsDir}/pluto-${plutoVersion}";

# set up apache tomcat for testing ...
my $apacheVersion = "8.0.20";
my $apacheDir = "${httpdsDir}/apache-tomcat-${apacheVersion}";

my $liferayHome = "";
my $servletImplDir = "";
my $deployDir = "";
my $log = "";
my $yet = 0;

# remove all archetypes previously installed locally
`rm -rf ~/.m2/archetype-catalog.xml`;
`rm -rf ~/.m2/repository/com/liferay/faces/maven/archetypes/*`;

# remove any stray war from previous run, just in case one is there ...
`rm -rf ${apacheDir}/webapps/myArtifactId-1.0-SNAPSHOT.war`;
`rm -rf ${apacheDir}/webapps/myArtifactId-1.0-SNAPSHOT`;
`rm -rf ${plutoDir}/tomcat-7.0.42/webapps/myArtifactId-1.0-SNAPSHOT.war`;
`rm -rf ${plutoDir}/tomcat-7.0.42/webapps/myArtifactId-1.0-SNAPSHOT`;
`rm -rf $liferayDir{$liferay6_2Version}/tomcat-*/webapps/myArtifactId-1.0-SNAPSHOT`;
`rm -rf $liferayDir{$liferay7_0Version}/tomcat-*/webapps/myArtifactId-1.0-SNAPSHOT`;

my @bundles = ("war", "wab");
my @containers = ("webapp", "pluto", "liferay");
my @jsfs = ("jsf-2.1", "jsf-2.2", "jsf-2.3");
my @components = ("jsf", "liferay-faces-alloy", "liferay-faces-metal", "primefaces", "richfaces", "icefaces");

my %versions = ();
@{$versions{"webapp"}} = ("1.0.x");
@{$versions{"liferay"}} = ("6.2.x", "7.0.x", "7.1.x");
@{$versions{"pluto"}}= ("2.0.x", "3.0.x");

my($bundle,$component,$container,$version,$jsf);

# set up a template for a prefix
my $prefix = "xmlns:PREFIX=\"http://some.org/some\"";

my %pre = ();
$pre{"jsf"} = "";

$_ = $prefix;
s/PREFIX/rich/;
s/some.org/richfaces.org/;
s/some/rich/;
$pre{"richfaces"} = $_;

$_ = $prefix;
s/PREFIX/p/;
s/some.org/primefaces.org/;
s/some/ui/;
$pre{"primefaces"} = $_;

# xmlns:icecore="http://www.icefaces.org/icefaces/core"
$_ = $prefix;
s/PREFIX/icecore/;
s/some.org/www.icefaces.org/;
s/some/icefaces\/core/;
$pre{"icefaces"} = $_;

# xmlns:ace="http://www.icefaces.org/icefaces/components"
$_ = $prefix;
s/PREFIX/ace/;
s/some.org/www.icefaces.org/;
s/some/icefaces\/components/;
$pre{"icefaces"} .= " " . $_;

$_ = $prefix;
s/PREFIX/alloy/;
s/some.org/liferay.com/;
s/some/faces\/alloy/;
$pre{"liferay-faces-alloy"} = $_;

$_ = $prefix;
s/PREFIX/metal/;
s/some.org/liferay.com/;
s/some/faces\/metal/;
$pre{"liferay-faces-metal"} = $_;

# set up a template for a dependency
my $dependency = <<'END_DEPENDENCY';
		<dependency>
			<groupId>com.some.co</groupId>
			<artifactId>some-impl</artifactId>
			<version>0.0.0</version>
		</dependency>
END_DEPENDENCY

# define some dependencies for the component suites
my %comp = ();
$comp{'jsf'} = "";

$_ = $dependency;
s/groupId>..*</groupId>org.primefaces</;
s/artifactId>..*</artifactId>primefaces</;
s/version>..*</version>6.0</;
$comp{'primefaces'} = $_;

$_ = $dependency;
s/groupId>..*</groupId>org.richfaces</;
s/artifactId>..*</artifactId>richfaces</;
s/version>..*</version>4.5.6.Final</;
$comp{'richfaces'} = $_;

$_ = $dependency;
s/groupId>..*</groupId>org.icefaces</;
s/artifactId>..*</artifactId>icefaces</;
s/version>..*</version>3.3.0</;
$comp{'icefaces'} = $_;

	$_ = $dependency;
	s/groupId>..*</groupId>org.icefaces</;
	s/artifactId>..*</artifactId>icefaces-ace</;
	s/version>..*</version>4.1.1</;
	$comp{'icefaces'} .= $_;

$_ = $dependency;
s/groupId>..*</groupId>com.liferay.faces.alloy</;
s/artifactId>..*</artifactId>liferay-faces-alloy</;
s/version>..*</version>2.0.0-SNAPSHOT</;
$comp{'liferay-faces-alloy'} = $_;

$_ = $dependency;
s/groupId>..*</groupId>com.liferay.faces.alloy</;
s/artifactId>..*</artifactId>liferay-faces-alloy-reslib</;
s/version>..*</version>2.0.0-SNAPSHOT</;
$comp{'liferay-faces-alloy-reslib'} = $_;

$_ = $dependency;
s/groupId>..*</groupId>com.liferay.faces.metal</;
s/artifactId>..*</artifactId>liferay-faces-metal</;
s/version>..*</version>1.0.0-SNAPSHOT</;
$comp{'liferay-faces-metal'} = $_;

$_ = $dependency;
s/groupId>..*</groupId>com.liferay.faces.metal</;
s/artifactId>..*</artifactId>liferay-faces-metal-reslib</;
s/version>..*</version>1.0.0-SNAPSHOT</;
$comp{'liferay-faces-metal-reslib'} = $_;

$_ = $dependency;
s/groupId>..*</groupId>com.liferay.faces.metal</;
s/artifactId>..*</artifactId>liferay-faces-metal-reslib</;
s/version>..*</version>1.0.0-SNAPSHOT</;
$comp{'liferay-faces-metal-reslib'} = $_;

$_ = $dependency;
s/groupId>..*</groupId>javax.enterprise</;
s/artifactId>..*</artifactId>cdi-api</;
s/version>..*</version>1.2</;
$comp{'cdi-api'} = $_;

# com.liferay.faces.util:liferay-faces-util:jar:3.0.0-SNAPSHOT:compile
$_ = $dependency;
s/groupId>..*</groupId>com.liferay.faces.util</;
s/artifactId>..*</artifactId>liferay-faces-util</;
s/version>..*</version>3.0.0-SNAPSHOT</;
$comp{'liferay-faces-util'} = $_;

# set up a template for a component to be included from the component suite, if any
my $id = "panelId";
my %openPanel = ();
my %closePanel = ();

$openPanel{"jsf"} = "<h:panelGroup id=\"$id\" styleClass=\"\$\{artifactId\}-hello-world\" layout=\"block\">";
$openPanel{"primefaces"} = "<p:panel id=\"$id\">";
$openPanel{"icefaces"} = "<ace:panel id=\"$id\">";
$openPanel{"richfaces"} = "<rich:panel id=\"$id\">";
$openPanel{"liferay-faces-alloy"} = "<alloy:panel id=\"$id\">";
$openPanel{"liferay-faces-metal"} = "<metal:panel id=\"$id\">";

$closePanel{"jsf"} = "</h:panelGroup>";
$closePanel{"primefaces"} = "</p:panel>";
$closePanel{"icefaces"} = "</ace:panel>";
$closePanel{"richfaces"} = "</rich:panel>";
$closePanel{"liferay-faces-alloy"} = "</alloy:panel>";
$closePanel{"liferay-faces-metal"} = "</metal:panel>";

# richfaces web.xml foo
(my $webDotXmlFoo = q{

	<!-- Enable RichFaces Resource Mapping -->
	<context-param>
		<param-name>org.richfaces.resourceMapping.enabled</param-name>
		<param-value>true</param-value>
	</context-param>

	<!-- The RichFaces Resource Servlet provides static resources for the rich:editor component. If it is invoked for -->
	<!-- for a resource that is not associated with the rich:editor component\, then it delegates to the FacesServlet. -->
	<servlet>
		<servlet-name>Resource Servlet</servlet-name>
		<servlet-class>org.richfaces.webapp.ResourceServlet</servlet-class>
		<load-on-startup>1</load-on-startup>
	</servlet>
	<servlet-mapping>
		<servlet-name>Resource Servlet</servlet-name>
		<url-pattern>/org.richfaces.resources/*</url-pattern>
	</servlet-mapping>

}) =~ s/^ {8}//mg;

# iterate over our dimensions of the archetypes to generate a list of all our archetypes
my %arch = ();

# $ echo "2 bundles * 3 contianers * 6? versions * 6 component suites * 3 versions of jsf" | bc
# 648 possible archetypes

for $bundle (@bundles) {
	for $container (@containers) {
		for $version (@{$versions{"$container"}}) {
			for $component (@components) {
				for $jsf(@jsfs) {

					# 1. applying filters
					next if ($bundle eq "jee" and $jsf ne "jsf-2.1");
					next if ($container eq "liferay" and $jsf eq "jsf-2.3");
					next if ($version eq "7.1.x" and $jsf eq "jsf-2.1");
					next if ($version eq "7.0.x" and $jsf eq "jsf-2.1");
					next if ($version eq "3.0.x" and $jsf eq "jsf-2.1");
					next if ($version eq "2.0.x" and $jsf eq "jsf-2.3");

					next if ($bundle eq "war");

					next unless ($version eq "7.0.x"); # liferay 7.0 only
					# next unless ($version eq "6.2.x"); # liferay 6.2 only
					# next unless ($version eq "2.0.x"); # pluto 2.0 only
					# next unless ($version eq "1.0.x"); # apache tomcat only

					next unless (
					 	$version eq "1.0.x" or
						$version eq "2.0.x" or
						$version eq "6.2.x" or
						$version eq "7.0.x"
					);

					# next if ($component eq "icefaces");  # skip IceFaces
					# next unless ($component =~ /jsf/);   # jsf only
					# next unless ($component =~ /alloy/); # AlloyFaces only
					# next unless ($component =~ /prime/); # PrimeFaces only
					# next unless ($component =~ /rich/);  # RichFaces only
					next unless ($component =~ /prime/ or $component =~ /jsf/); # primefaces and jsf only

					# print "${component}-${bundle}-${container}" . (($version) ? "-" : "") . "${version}-${jsf}-archetype\n";
					$arch{"${component} ${bundle} ${container} ${version} $jsf"} += 1;

					# 2. simply manually add individual filters allowing only the archetypes we vote to release
					# next if not in "this" list
				}
			}
		}
	}
}

# create an empty directory to store our new archetypes
my $dir = "deps/archetypes";
if (-d "$dir") { `rm -rf $dir`; }
mkpath("$dir");

# setup basic dependency version numbers

# Branch Artifact                           Liferay Bridge Portlet JSF
# ------ ---------------------------------- ------- ------ ------- ---
# 6.0.x  liferay-faces-bridge-ext-6.0.0.jar 7.1.x   5.0.x  3.0     2.2
# master liferay-faces-bridge-ext.jar       7.0.x   4.0.x  2.0     2.2 ???   i   _ t   i      ???
# 5.0.x  liferay-faces-bridge-ext-5.0.0.jar 7.0.x   4.0.x  2.0     2.2 ??? f   x     h   s    ???
# 4.0.x  liferay-faces-bridge-ext-4.0.0.jar 7.0.x   3.0.x  2.0     2.1
# 3.0.x  liferay-faces-bridge-ext-3.0.0.jar 6.2.x   4.0.x  2.0     2.2
# 2.0.x  liferay-faces-bridge-ext-2.0.0.jar 6.2.x   3.0.x  2.0     2.1

my %mojarra_version = ();
$mojarra_version{"jsf-2.1"} = "2.1.29-04";
$mojarra_version{"jsf-2.2"} = "2.2.13";
$mojarra_version{"jsf-2.3"} = "2.3.0-m06-SNAPSHOT";

my %impl_version = ();
$impl_version{"jsf-2.1:2.0.x"} = "3.0.0-SNAPSHOT";
$impl_version{"jsf-2.2:2.0.x"} = "4.0.0-SNAPSHOT";
$impl_version{"jsf-2.2:3.0.x"} = "5.0.0-SNAPSHOT";
$impl_version{"jsf-2.3:3.0.x"} = "5.0.0-SNAPSHOT";

$impl_version{"jsf-2.1:6.2.x"} = "3.0.0-SNAPSHOT";
$impl_version{"jsf-2.2:6.2.x"} = "4.0.0-SNAPSHOT";
$impl_version{"jsf-2.1:7.0.x"} = "3.0.0-SNAPSHOT";
$impl_version{"jsf-2.2:7.0.x"} = "4.0.0-SNAPSHOT";
$impl_version{"jsf-2.2:7.1.x"} = "5.0.0-SNAPSHOT";

my %ext_version = ();
$ext_version{"jsf-2.1:6.2.x"} = "2.0.0-SNAPSHOT";
$ext_version{"jsf-2.2:6.2.x"} = "3.0.0-SNAPSHOT";
$ext_version{"jsf-2.1:7.0.x"} = "4.0.0-SNAPSHOT";
$ext_version{"jsf-2.2:7.0.x"} = "5.0.0-SNAPSHOT";
$ext_version{"jsf-2.2:7.1.x"} = "6.0.0-SNAPSHOT";

# generate archetypes from our list
my $now = time();
my($a,$path);
my($artifactId,$name,$ver,$description);
my @archs = reverse sort keys %arch;
for $a (@archs) {
	($component,$bundle,$container,$version,$jsf) = split " ", "    ";
	($component,$bundle,$container,$version,$jsf) = split " ", $a;
	$path = "$dir/$component/$bundle/$container/$version/$jsf";

	print "$component/$bundle/$container/$version/$jsf ...";

	$artifactId = "${component}-" . (($container eq "webapp") ? "webapp" : "portlet-${container}") . "-${jsf}-archetype";
	$name = "${component} " . (($container eq "webapp") ? "webapp" : "portlet ${container}") . " ${jsf} archetype";
	$description = "Provides a " . ucfirst($container) . " archetype to create a " . $component . " component application.";

	$_ = $version;
	s/\.x/.0-SNAPSHOT/;
	$ver = $_;

	$_ = `pwd`; chomp;
	my $here = $_;

	mkpath "$path";
	if ($container eq "webapp") {
		$deployDir="${apacheDir}/webapps";
		$log = "${apacheDir}/logs/catalina.out";

		if (-f $log) {
			$now = time(); `echo $0: $now: $path: building ... >>$log`;
		}
		`cp -pr archetype_seeds/jsf-webapp-jsf-2.1-archetype-1.0.x/* $path/.`;
	}
	if ($container eq "pluto") {
		$deployDir="${plutoDir}/tomcat-7.0.42/webapps";
		$log = "${plutoDir}/tomcat-7.0.42/logs/catalina.out";

		if (-f $log) {
			$now = time(); `echo $0: $now: $path: building ... >>$log`;
		}
		`cp -pr archetype_seeds/jsf-portlet-pluto-$jsf-archetype-2.0.x/* $path/.`;
	}
	if ($container eq "liferay") {
		if ($version =~ /^6.2/) { $liferayHome = $liferayDir{$liferay6_2Version}; }
		if ($version =~ /^7.0/) { $liferayHome = $liferayDir{$liferay7_0Version}; }
		$deployDir = "${liferayHome}/deploy";

		$_ = `ls -d ${liferayHome}/tomcat-* 2>>/dev/null`; chomp;
		$servletImplDir = $_;
		$log = "${servletImplDir}/logs/catalina.out";

		if (-f $log) {
			$now = time(); `echo $0: $now: $path: building ... >>$log`;
		}
		if ($version =~ /^6.2/) {
			`cp -pr archetype_seeds/jsf-portlet-liferay-$jsf-archetype-6.2.x/* $path/.`;
		}
		if ($version =~ /^7.0/) {
			`cp -pr archetype_seeds/jsf-portlet-wab-liferay-$jsf-archetype-7.0.x/* $path/.`;
		}
	}

	# fix the archetype
	find(\&fix, "$path");

	# install the artifact, if any
	chdir $path or die "cannot chdir to $path: $!\n";
	if (-f "pom.xml") {

		# install the generated archetype
		if (-f $log) {
			$now = time(); `echo $0: $now: $path: clean install ... >>$log`;
		}
		`mvn clean install >>mvn_clean_install.log 2>>mvn_clean_install.log`;

		mkdir "try" or die "cannot mkdir 'try': $!\n";
		chdir "try" or die "cannot chdir to $path/try: $!\n";

		# generate the archetype's application source
		if (-f $log) {
			$now = time(); `echo $0: $now: $path: archetype:generate ... >>$log`;
		}
		print " archetype:generate ...";
		`mvn -B archetype:generate -DarchetypeGroupId=com.liferay.faces.maven.archetypes -DarchetypeArtifactId=$artifactId -DarchetypeVersion=$ver -DgroupId=myGroupId -DartifactId=myArtifactId >>mvn_archetype_generate.log 2>>mvn_archetype_generate.log`;

		# build the application, if any
		chdir "myArtifactId" or die "cannot chdir to $here/try/myArtifactId: $!\n";
		if (-f "pom.xml") {

			# build the application
			if (-f $log) {
				$now = time(); `echo $0: $now: $path: clean package ... >>$log`;
			}
			print " package ...";
			# `mvn clean package >>mvn_clean_package.log 2>>mvn_clean_package.log`;
			my $cmd = "mvn clean package >>mvn_clean_package.log 2>>mvn_clean_package.log";
			system($cmd);
			if ($? == -1) { print "failed to execute $cmd: $!\n"; }
			elsif ($? & 127) { printf "child of $cmd died with signal %d, %s coredump\n", ($? & 127),  ($? & 128) ? 'with' : 'without'; }
			# else { printf "child of $cmd exited with (" . $? . ") value => %d\n", $? >> 8; }
      	if ($? >> 8) {
				print `grep ERROR mvn_clean_package.log | head -1` . "\n";
				chdir $here or die "cannot chdir back to $here: $!\n";
				next;
			}

			if (-f $log) {
				$now = time(); `echo $0: $now: $path: gradle init ... >>$log`;
			}
			print " gradle ...";
			$cmd = "gradle init >>gradle_init.log 2>>gradle_init.log";
			system($cmd);
			if ($? == -1) { print "failed to execute $cmd: $!\n"; }
			elsif ($? & 127) { printf "child of $cmd died with signal %d, %s coredump\n", ($? & 127),  ($? & 128) ? 'with' : 'without'; }
			# else { printf "child of $cmd exited with (" . $? . ") value => %d\n", $? >> 8; }
			if ($? >> 8) {
				print `grep -i ERROR gradle_init.log | head -1` . "\n";
				chdir $here or die "cannot chdir back to $here: $!\n";
				next;
			}

			# maybe ... deploy, test, and undeploy the application
			if ($ARGV[0] and $ARGV[0] =~ /test/ ) {
				if ($version eq "7.0.x" or $version eq "6.2.x" or $version eq "2.0.x" or $version eq "1.0.x") {

					if (-f $log) {
						$now = time(); `echo $0: $now: $path: deploying ... >>$log`;
					}
					print " deploy ...";
					`cp target/*.war ${deployDir}/.`;
					if ($container eq "liferay") {
						&wait_for_liferay_deployment($now);
					}
					if ($container eq "pluto") {
						&wait_for_pluto_deployment($now);
					}
					if ($container eq "webapp") {
						&wait_for_webapp_deployment($now);
					}

					if (-f $log) {
						$now = time(); `echo $0: $now: $path: testing ... >>$log`;
					}
					print " test ...";
					`mvn -Dtest=com.liferay.faces.test.MyArtifactIdTester test >>test.out 2>>test.out`;

					print " undeploy ...";
					if (-f $log) {
						$now = time(); `echo $0: $now: $path: removing the application ... >>$log`;
					}
					if ($container eq "liferay") {
						`rm -rf ${servletImplDir}/webapps/myArtifactId-1.0-SNAPSHOT`;
					}
					if ($container eq "pluto") {
						`rm -rf ${plutoDir}/tomcat-7.0.42/webapps/myArtifactId-1.0-SNAPSHOT.war`;
						`rm -rf ${plutoDir}/tomcat-7.0.42/webapps/myArtifactId-1.0-SNAPSHOT`;
					}
					if ($container eq "webapp") {
						`rm -rf ${apacheDir}/webapps/myArtifactId-1.0-SNAPSHOT.war`;
						`rm -rf ${apacheDir}/webapps/myArtifactId-1.0-SNAPSHOT`;
					}
					&wait_for_undeployment($now);
				}
			}

			print " done.\n";
		}
	}

	chdir $here or die "cannot chdir back to $here: $!\n";
}

sub fix {

	my $file = $_;

	my $key = "$jsf:$version";

	# fix the archetype parent pom files to use the correct info
	if ($file eq "pom.xml" and $File::Find::name !~ /archetype-resources/) {
		# print "    fixing: $File::Find::name\n";

		# <groupId>com.liferay.faces.maven.archetypes</groupId>
		# <artifactId>jsf-portlet-pluto-archetype</artifactId>

		`perl -pi -e 's/^	<artifactId>..*</	<artifactId>$artifactId</g' $file`;

		# <packaging>maven-archetype</packaging>
		# <name>JSF Portlet Pluto Archetype</name>
		`perl -pi -e 's/^	<name>..*</	<name>$name</g' $file`;

		# <version>2.0.0-SNAPSHOT</version>
		`perl -pi -e 's/^	<version>..*</	<version>$ver</g' $file`;

		# <description>Provides an archetype to create JSF portlets for Pluto.</description>
		`perl -pi -e 's/^	<description>..*</	<description>$description</g' $file`;

	}

	# fix the archetype.xml
	if ($file eq "archetype.xml") {
		# print "    fixing: $File::Find::name\n";

		# <id>jsf-portlet-liferay-archetype</id>
		`perl -pi -e 's/^	<id>..*</	<id>$artifactId</g' $file`;
	}

	# fix the archetype-metadata.xml
	if ($file eq "archetype-metadata.xml") {
		# print "    fixing: $File::Find::name\n";

		# <archetype-descriptor name="jsf-portlet-liferay-archetype">
		`perl -pi -e 's/archetype-descriptor name="..*"/archetype-descriptor name="$artifactId"/' $file`;
	}

	##### fix archetype-resources below here #####

	# fix the archetype resource pom files to use the correct impl and ext versions, if any
	if ($file eq "pom.xml" and $File::Find::name =~ /archetype-resources/) {
		# print "    fixing: $File::Find::name $key\n";

# 		if (defined($ext_version{$key})) { 
# 	      print "	$impl_version{$key} $ext_version{$key}\n";
# 		} else {
# 	      print "	$impl_version{$key}\n";
# 		}

		# <liferay.faces.bridge.impl.version>3.0.0-SNAPSHOT</liferay.faces.bridge.impl.version>
		if ($container ne "webapp") {
			`perl -pi -e 's/liferay.faces.bridge.impl.version>[34].0.0-SNAPSHOT</liferay.faces.bridge.impl.version>$impl_version{"$key"}</g' $file`;
			# print `grep "liferay.faces.bridge.impl.version>" $file`;
		}

		# <liferay.faces.bridge.ext.version>2.0.0-SNAPSHOT</liferay.faces.bridge.ext.version>
		if ($container eq "liferay") {
			`perl -pi -e 's/liferay.faces.bridge.ext.version>[23].0.0-SNAPSHOT</liferay.faces.bridge.ext.version>$ext_version{"$key"}</g' $file`;
			# print `grep "liferay.faces.bridge.ext.version>" $file`;
		}

		# add dependency for any component suite
		$_ = $comp{"$component"};
		s,/,\\/,g;
		s,<,\\<,g;
		s,>,\\>,g;
		`perl -pi -e 's/.<\\/dependencies>/$_	<\\/dependencies>/g' $file`;

		if ($container eq "webapp") {

			if ($component =~ /liferay/ and $jsf ne "jsf-2.1") {
				$_ = $comp{"liferay-faces-util"};
				s,/,\\/,g;
				s,<,\\<,g;
				s,>,\\>,g;
				`perl -pi -e 's/.<\\/dependencies>/$_	<\\/dependencies>/g' $file`;
			}

			# <mojarra.version>2.1.29-04</mojarra.version>
			`perl -pi -e 's/mojarra.version>2.1.29-04</mojarra.version>$mojarra_version{"$jsf"}</g' $file`;

			# SEVERE [localhost-startStop-7] com.sun.faces.config.ConfigureListener.contextInitialized Critical error during deployment: 
			# java.lang.NoClassDefFoundError: javax/enterprise/context/spi/Contextual
			# ...
			# Caused by: java.lang.ClassNotFoundException: javax.enterprise.context.spi.Contextual
			if ($component eq "primefaces" and $jsf eq "jsf-2.3") {
				$_ = $comp{"cdi-api"};
				s,/,\\/,g;
				s,<,\\<,g;
				s,>,\\>,g;
				`perl -pi -e 's/.<\\/dependencies>/$_	<\\/dependencies>/g' $file`;
			}
		}

		# add reslib dependency if necessary
		if ($component =~ /liferay/ and $container eq "webapp") {
			$_ = $comp{"${component}-reslib"};
			s,/,\\/,g;
			s,<,\\<,g;
			s,>,\\>,g;
			`perl -pi -e 's/.<\\/dependencies>/$_	<\\/dependencies>/g' $file`;
		}
	}

	# fix the view.xhtml
	if ($file eq "view.xhtml") {

		# establish the prefix for the component suite
		$_ = $pre{"$component"};

		# ERROR: 
		# String found where operator expected at -e line 1, at end of line
		# (Missing semicolon on previous line?)
		# Can't find string terminator '"' anywhere before EOF at -e line 1.
		s,/,\\/,g;

		# print "    fixing: $File::Find::name $component $_\n";
		`perl -pi -e 's/^>/	$_\n>/g' $file`;

		# wrap the hello world text with a panel from the component suite
		$_ = $openPanel{"$component"};
		s,\{,\\{,g;
		s,\},\\},g;
		s,\$,\\\$,g;
		# print "    fixing: $File::Find::name $component $_\n";
		`perl -pi -e 's/<h:outputText style/$_\n\t\t\t<h:outputText style/' $file`;

		$_ = $closePanel{"$component"};
		s,/,\\/,g;
		# print "    fixing: $File::Find::name $component $_\n";
		`perl -pi -e 's/<ul/$_\n\t\t<ul/' $file`;

		if ($component eq "primefaces") {
			# `perl -pi -e 's/<ul>/<ul>\n\t\t\t<li><em><h:outputText value="#\{bridgeContext.bridgeConfig.attributes\[PRIMEFACES\]\}" \/><\/em><\/li>/' $file`;
			# `perl -pi -e "s/PRIMEFACES/'PRIMEFACES'/" $file`;
		}

	}

	# fix the MyArtifactIdTester.java
	if ($file eq "MyArtifactIdTester.java") {
		if ($version =~ /^7.0/) {
			`perl -pi -e 's,:9080/,:8080/,' $file`;
		}
		if ($container eq "webapp") {
			`perl -pi -e 's,:9080/web/guest,:8080,' $file`;
			`perl -pi -e 's,/arch,/myArtifactId-1.0-SNAPSHOT,' $file`;
			`perl -pi -e 's,:panelId,panelId,' $file`;
		}
	}

	if ($file eq "web.xml") {
		if ($component eq "richfaces") {
			`perl -pi -e 's,</web-app>,	$webDotXmlFoo\n</web-app>,' $file`;
		}
	}
}

# Deployment of web application archive ..*myArtifactId-1.0-SNAPSHOT.war has finished in
sub wait_for_webapp_deployment() {
	$now = shift;
	@_ = (
		$now,
		"Deployment of web application archive ..*myArtifactId-1.0-SNAPSHOT.war has finished in",
		"waiting for myArtifactId-1.0-SNAPSHOT to be deployed ..."
	);
	&monitor(@_);
}

# Initializing Mojarra 2.2.12 ..* for context '/myArtifactId-1.0-SNAPSHOT'
sub wait_for_pluto_deployment() {
	$now = shift;
	@_ = (
		$now,
		"Initializing ..* for context '/myArtifactId-1.0-SNAPSHOT'",
		"waiting for myArtifactId-1.0-SNAPSHOT to be deployed ..."
	);
	&monitor(@_);
}

sub wait_for_liferay_deployment() {
	$now = shift;
	@_ = (
		$now,
		"portlet for myArtifactId-1.0-SNAPSHOT is available for use",
		"waiting for myArtifactId-1.0-SNAPSHOT to be deployed ..."
	);
	&monitor(@_);
}

# Undeploying context [/myArtifactId-1.0-SNAPSHOT]
sub wait_for_undeployment() {
	$now = shift;
	@_ = (
		$now,
		"Undeploying context ./myArtifactId-1.0-SNAPSHOT.",
		"waiting for myArtifactId-1.0-SNAPSHOT to be undeployed ..."
	);
	&monitor(@_);
}

sub wait_for_liferay_undeployment() {
	$now = shift;
	@_ = (
		$now,
		"INFO: Undeploying context ./myArtifactId-1.0-SNAPSHOT.",
		"waiting for myArtifactId-1.0-SNAPSHOT to be undeployed ..."
	);
	&monitor(@_);
}

# monitor sub routine
# assumes two globals $yet and $log
# $yet is a whole number describing the number of lines of $log just checked and then spewed out 
# $log is the file being checked
#
# 4 parameters: 
# 1 = $now or $epoch is a whole number which limits the check to occurrences after "$now:" in the $log, if $now > 0 
# 2 = the pattern used by grep for checking ... used over and over.  Must return true if monitoring is over, and false if not 
# 3 = message is a string to be sent to the terminal, unless the monitor encounters a new 'phase' in the log 
# 4 = an optional command to run after monitoring is over, in lew of spewing the last of the log file ... 
sub monitor() {

   $_ = shift;
   # make 'now' a whole number, or 0.
   my $epoch = (/^\d+$/) ? $_ : 0;

   my $pattern = shift;
   my $message = shift;
   my $finish = shift;
  
   my $waiting = 1;
   my $spewed = 0;
   while ($waiting == 1 ) {
      &spew($spewed);
      $spewed = ($spewed + $yet);
      sleep 1;

      $_ = `grep "^phase: " $log | tail -1 | cut -c8-`; chomp;
      $message = ($_) ? $_ : $message;
      # print "$0: $message\n";

      my $file = $log;

      # if there is an epoch specified, then ensure that the check
      # is limited to the portion of the %log occurring after '$epoch:'
      my $tmp = "/tmp/check_${$}";
      if ($epoch) {
			$_ = `date +%s`; chomp;
         `grep -A $_ $epoch: $log >$tmp`;
         $file = $tmp;
      }

      # check and see if we are done ...
      system("grep", "--quiet", $pattern, $file);
      $waiting = $? >> 8;

      if (-f $tmp) { unlink $tmp or die "cannot unlink $tmp: $!\n"; }

      sleep 1;
   }

   if ($finish) {
      system($finish);
      if ($? == -1) { print "failed to execute $finish: $!\n"; }
      elsif ($? & 127) { printf "child of $finish died with signal %d, %s coredump\n", ($? & 127),  ($? & 128) ? 'with' : 'without'; }
      else { printf "child of $finish exited with (" . $? . ") value => %d\n", $? >> 8; }
   } else {
      &spew($spewed);
   }
}

sub spew {

   my $already = shift;

   if (-f $log) {

      $_ = `wc -l $log`;
      s/^\s+//;
      @_ = split;
      my $lines = $_[0];

      $yet = $lines - $already;
      if ($yet > 0) {
			# uncomment the next line if you'd like to see the log scroll by (or spew) ...
         # if ($yet < 300 ) { print `tail -${yet} $log`; } else { print `tail -5 $log`; }
      }
   }
}

