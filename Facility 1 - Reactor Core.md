This is a document for the plasma reactor core design and construction.

![Reactor Core](/image/pcore.jpeg "Reactor Core")

^ Reactor Core mockup ^

## Description:

This is a reactor core which generates a limitless amount of power by extracting the energy from the shield.

# Section 1 - Main & useful information
## Part 1 - The energy
#### What:

The reactor’s fuel source is other energy sources like solar, wind, hydro, fossil fuels, and others. The fuel doesn’t actually power it but it uses the energy generated from it to power the reactor.

#### Who:

This project in reality is only made by me.
If this does become mainstream, this will be designed and constructed by ~30,000 people.

#### When:

This project will be finished by (probably) 2027.

#### Where:

The sources will be many of the common other energy sources which is of the following:
1. Fossil Fuels
1. Hydro Dams
1. Wind Turbines
1. Solar Power
1. Nuclear Power

and more.

#### Why:

The reactor needs energy to start the initial fusion process before it’s self-sustaining.

#### How:
The sources will generate energy which will be stored in a battery before being delivered straight to the plasma generator, which will use the energy to fuse hydrogen atoms together and generate lots of energy in the process.

## Part 2 - The lasers

#### Main Lasers
>This is the two primary lasers required to start and sustain the reactor.
>The main lasers is required because these are the power beams, used to sustain and actually start the reactor.
>If these are not available, the reactor would not start.  
>How:
>>The main fuel & hydrogen source is delivered from here which is one of the primary reasons why this is nesscary.
>>It also heats the reactor enough to continue and regulate the nuclear fusion.

#### Power Lasers
>These are the lasers to determine if the reaction should be fast and hot or slow and cold. These are also adjustable.
>While you don't technically need the power lasers, the reactor won't be sustainable this way.
>The fuel & hydrogen source is also delivered here in the form of plasma.

#### Stablization Lasers
>These are the most important lasers because these regulate and stablize (hence the name) the fusion inside the core.
>If there's a defect in these, this will cause the reactor to destablize and cause a thermal runaway and explode the entire facility.
>How this works is that it shoots lasers at the shield to power it. While it's doing that, it pulls out the extra helium and splits it back into hydrogen which is delivered back to the reactor via the main lasers.

## Part 3 - The startup process
Here is how the startup works:
1. You press a button.
1. From here, it calls the server function (`startupCore()`) which will do the following:
    1. It diverts around 95% of the power from the facility to the reactor, reserving the remaining 5% for a few lights and the screen.
    1. The server daemon calls the coprocess `coreStartup` which will actually do the heavy work.
1. After the server finished it's init process, the `coreStartup` daemon will take over.
    1. First, it initializes the hydrogen delivery gas pipes.
    1. It then sends the the 95% power from the init to power to start the main lasers.
        1. This will cause a combustion process which will have the fire loaded with microwave energy and smelted with >50K*C temperatures to generate plasma.
    1. If manual mode was enabled, this is where you will take over.
    1. If `--manual-start` or `(manual)` was not passed, it continues the process.
        1. It does a while loop to repeat similar steps above to do the stablization lasers, and the power lasers.
    1. It opens the chamber and.... (BOOOOOOOOOOOOOOOOOM!!!!!)
    1. Extremely hot plasma (>35K\*C) will pipe through the laser structure and then concentrated on the center of the chamber. The reactor will start the fusion process with the temperature in the very center (with the size of less than 0.5 millimeters) being over 45M\*C.
    1. The stablizations lasers come into play here where the shield gets immediatly generated and reaches 100% capacity. The SLs will pull the excess helium out and turn it back into hydrogen within 450ms.
    1. The PLs will reduce the power down to 20%, enough to lower it's instability enough that it won't be an issue.

The startup will be done from here.