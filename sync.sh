
# 5.x
dir=~/Projects/liferay.com/liferay-faces/liferay-faces-bridge-ext-5.x/archetype/icefaces-portlet
if [ ! -d $dir ]; then mkdir -p $dir && echo made $dir ...; fi
dir=~/Projects/liferay.com/liferay-faces/liferay-faces-bridge-ext-5.x/archetype/jsf-portlet
if [ ! -d $dir ]; then mkdir -p $dir && echo made $dir ...; fi
dir=~/Projects/liferay.com/liferay-faces/liferay-faces-bridge-ext-5.x/archetype/liferay-faces-alloy-portlet
if [ ! -d $dir ]; then mkdir -p $dir && echo made $dir ...; fi
dir=~/Projects/liferay.com/liferay-faces/liferay-faces-bridge-ext-5.x/archetype/liferay-faces-metal-portlet
if [ ! -d $dir ]; then mkdir -p $dir && echo made $dir ...; fi
dir=~/Projects/liferay.com/liferay-faces/liferay-faces-bridge-ext-5.x/archetype/primefaces-portlet
if [ ! -d $dir ]; then mkdir -p $dir && echo made $dir ...; fi
dir=~/Projects/liferay.com/liferay-faces/liferay-faces-bridge-ext-5.x/archetype/richfaces-portlet
if [ ! -d $dir ]; then mkdir -p $dir && echo made $dir ...; fi

# 4.x
dir=~/Projects/liferay.com/liferay-faces/liferay-faces-bridge-ext-4.x/archetype/icefaces-portlet
if [ ! -d $dir ]; then mkdir -p $dir && echo made $dir ...; fi
dir=~/Projects/liferay.com/liferay-faces/liferay-faces-bridge-ext-4.x/archetype/jsf-portlet
if [ ! -d $dir ]; then mkdir -p $dir && echo made $dir ...; fi
dir=~/Projects/liferay.com/liferay-faces/liferay-faces-bridge-ext-4.x/archetype/liferay-faces-alloy-portlet
if [ ! -d $dir ]; then mkdir -p $dir && echo made $dir ...; fi
dir=~/Projects/liferay.com/liferay-faces/liferay-faces-bridge-ext-4.x/archetype/liferay-faces-metal-portlet
if [ ! -d $dir ]; then mkdir -p $dir && echo made $dir ...; fi
dir=~/Projects/liferay.com/liferay-faces/liferay-faces-bridge-ext-4.x/archetype/primefaces-portlet
if [ ! -d $dir ]; then mkdir -p $dir && echo made $dir ...; fi
dir=~/Projects/liferay.com/liferay-faces/liferay-faces-bridge-ext-4.x/archetype/richfaces-portlet
if [ ! -d $dir ]; then mkdir -p $dir && echo made $dir ...; fi

# 3.x
dir=~/Projects/liferay.com/liferay-faces/liferay-faces-bridge-ext-3.x/archetype/icefaces-portlet
if [ ! -d $dir ]; then mkdir -p $dir && echo made $dir ...; fi
dir=~/Projects/liferay.com/liferay-faces/liferay-faces-bridge-ext-3.x/archetype/jsf-portlet
if [ ! -d $dir ]; then mkdir -p $dir && echo made $dir ...; fi
dir=~/Projects/liferay.com/liferay-faces/liferay-faces-bridge-ext-3.x/archetype/liferay-faces-alloy-portlet
if [ ! -d $dir ]; then mkdir -p $dir && echo made $dir ...; fi
dir=~/Projects/liferay.com/liferay-faces/liferay-faces-bridge-ext-3.x/archetype/liferay-faces-metal-portlet
if [ ! -d $dir ]; then mkdir -p $dir && echo made $dir ...; fi
dir=~/Projects/liferay.com/liferay-faces/liferay-faces-bridge-ext-3.x/archetype/primefaces-portlet
if [ ! -d $dir ]; then mkdir -p $dir && echo made $dir ...; fi
dir=~/Projects/liferay.com/liferay-faces/liferay-faces-bridge-ext-3.x/archetype/richfaces-portlet
if [ ! -d $dir ]; then mkdir -p $dir && echo made $dir ...; fi

# 2.x
dir=~/Projects/liferay.com/liferay-faces/liferay-faces-bridge-ext-2.x/archetype/icefaces-portlet
if [ ! -d $dir ]; then mkdir -p $dir && echo made $dir ...; fi
dir=~/Projects/liferay.com/liferay-faces/liferay-faces-bridge-ext-2.x/archetype/jsf-portlet
if [ ! -d $dir ]; then mkdir -p $dir && echo made $dir ...; fi
dir=~/Projects/liferay.com/liferay-faces/liferay-faces-bridge-ext-2.x/archetype/liferay-faces-alloy-portlet
if [ ! -d $dir ]; then mkdir -p $dir && echo made $dir ...; fi
dir=~/Projects/liferay.com/liferay-faces/liferay-faces-bridge-ext-2.x/archetype/liferay-faces-metal-portlet
if [ ! -d $dir ]; then mkdir -p $dir && echo made $dir ...; fi
dir=~/Projects/liferay.com/liferay-faces/liferay-faces-bridge-ext-2.x/archetype/primefaces-portlet
if [ ! -d $dir ]; then mkdir -p $dir && echo made $dir ...; fi
dir=~/Projects/liferay.com/liferay-faces/liferay-faces-bridge-ext-2.x/archetype/richfaces-portlet
if [ ! -d $dir ]; then mkdir -p $dir && echo made $dir ...; fi

rsync -vax deps/archetypes/icefaces/war/liferay/7.0.x/jsf-2.2/* ~/Projects/liferay.com/liferay-faces/liferay-faces-bridge-ext-5.x/archetype/icefaces-portlet/.
rsync -vax deps/archetypes/jsf/war/liferay/7.0.x/jsf-2.2/* ~/Projects/liferay.com/liferay-faces/liferay-faces-bridge-ext-5.x/archetype/jsf-portlet/.
rsync -vax deps/archetypes/liferay-faces-alloy/war/liferay/7.0.x/jsf-2.2/* ~/Projects/liferay.com/liferay-faces/liferay-faces-bridge-ext-5.x/archetype/liferay-faces-alloy-portlet/.
rsync -vax deps/archetypes/liferay-faces-metal/war/liferay/7.0.x/jsf-2.2/* ~/Projects/liferay.com/liferay-faces/liferay-faces-bridge-ext-5.x/archetype/liferay-faces-metal-portlet/.
rsync -vax deps/archetypes/primefaces/war/liferay/7.0.x/jsf-2.2/* ~/Projects/liferay.com/liferay-faces/liferay-faces-bridge-ext-5.x/archetype/primefaces-portlet/.
rsync -vax deps/archetypes/richfaces/war/liferay/7.0.x/jsf-2.2/* ~/Projects/liferay.com/liferay-faces/liferay-faces-bridge-ext-5.x/archetype/richfaces-portlet/.

# 4.x
rsync -vax deps/archetypes/icefaces/war/liferay/7.0.x/jsf-2.1/* ~/Projects/liferay.com/liferay-faces/liferay-faces-bridge-ext-4.x/archetype/icefaces-portlet/.
rsync -vax deps/archetypes/jsf/war/liferay/7.0.x/jsf-2.1/* ~/Projects/liferay.com/liferay-faces/liferay-faces-bridge-ext-4.x/archetype/jsf-portlet/.
rsync -vax deps/archetypes/liferay-faces-alloy/war/liferay/7.0.x/jsf-2.1/* ~/Projects/liferay.com/liferay-faces/liferay-faces-bridge-ext-4.x/archetype/liferay-faces-alloy-portlet/.
rsync -vax deps/archetypes/liferay-faces-metal/war/liferay/7.0.x/jsf-2.1/* ~/Projects/liferay.com/liferay-faces/liferay-faces-bridge-ext-4.x/archetype/liferay-faces-metal-portlet/.
rsync -vax deps/archetypes/primefaces/war/liferay/7.0.x/jsf-2.1/* ~/Projects/liferay.com/liferay-faces/liferay-faces-bridge-ext-4.x/archetype/primefaces-portlet/.
rsync -vax deps/archetypes/richfaces/war/liferay/7.0.x/jsf-2.1/* ~/Projects/liferay.com/liferay-faces/liferay-faces-bridge-ext-4.x/archetype/richfaces-portlet/.

# 3.x
rsync -vax deps/archetypes/icefaces/war/liferay/6.2.x/jsf-2.2/* ~/Projects/liferay.com/liferay-faces/liferay-faces-bridge-ext-3.x/archetype/icefaces-portlet/.
rsync -vax deps/archetypes/jsf/war/liferay/6.2.x/jsf-2.2/* ~/Projects/liferay.com/liferay-faces/liferay-faces-bridge-ext-3.x/archetype/jsf-portlet/.
rsync -vax deps/archetypes/liferay-faces-alloy/war/liferay/6.2.x/jsf-2.2/* ~/Projects/liferay.com/liferay-faces/liferay-faces-bridge-ext-3.x/archetype/liferay-faces-alloy-portlet/.
rsync -vax deps/archetypes/liferay-faces-metal/war/liferay/6.2.x/jsf-2.2/* ~/Projects/liferay.com/liferay-faces/liferay-faces-bridge-ext-3.x/archetype/liferay-faces-metal-portlet/.
rsync -vax deps/archetypes/primefaces/war/liferay/6.2.x/jsf-2.2/* ~/Projects/liferay.com/liferay-faces/liferay-faces-bridge-ext-3.x/archetype/primefaces-portlet/.
rsync -vax deps/archetypes/richfaces/war/liferay/6.2.x/jsf-2.2/* ~/Projects/liferay.com/liferay-faces/liferay-faces-bridge-ext-3.x/archetype/richfaces-portlet/.

# 2.x
rsync -vax deps/archetypes/icefaces/war/liferay/6.2.x/jsf-2.1/* ~/Projects/liferay.com/liferay-faces/liferay-faces-bridge-ext-2.x/archetype/icefaces-portlet/.
rsync -vax deps/archetypes/jsf/war/liferay/6.2.x/jsf-2.1/* ~/Projects/liferay.com/liferay-faces/liferay-faces-bridge-ext-2.x/archetype/jsf-portlet/.
rsync -vax deps/archetypes/liferay-faces-alloy/war/liferay/6.2.x/jsf-2.1/* ~/Projects/liferay.com/liferay-faces/liferay-faces-bridge-ext-2.x/archetype/liferay-faces-alloy-portlet/.
rsync -vax deps/archetypes/liferay-faces-metal/war/liferay/6.2.x/jsf-2.1/* ~/Projects/liferay.com/liferay-faces/liferay-faces-bridge-ext-2.x/archetype/liferay-faces-metal-portlet/.
rsync -vax deps/archetypes/primefaces/war/liferay/6.2.x/jsf-2.1/* ~/Projects/liferay.com/liferay-faces/liferay-faces-bridge-ext-2.x/archetype/primefaces-portlet/.
rsync -vax deps/archetypes/richfaces/war/liferay/6.2.x/jsf-2.1/* ~/Projects/liferay.com/liferay-faces/liferay-faces-bridge-ext-2.x/archetype/richfaces-portlet/.

