# Projektets Namn

## Beskrivning

ByggarNs 3dskrivarhandel är en webbshop där man kan köpa 3dskrivare och möjligen reservdelar och accessoarerer. När man köper något får man en order som sparas i handelns databas, man ska som användare och admin kunna gå tillbaka och se sina ordrar och kunna lägga en ny likadan eller liknande. En användare ska kunna ha många orders och ordrarna kan innehålla många skrivare/tillbehör med många taggar, t ex att en skrivare har direkt/bowdenmatning, vilka material den stödjer, rörelsesystem osv... dessa taggar används för att kunna filtera webbshoppen så att man bara ser de skrivarna man vill ha, säg en corexyskrivare med bowdenextruder.    

## Användare och roller

Här skriver du ner vilka typer av användare (som i inloggade användare) det finns, och vad de har för rättigheter, det vill säga, vad de kan göra (tänk admin, standard användare, etc).

Gästanvändare - oinloggad.
Kan söka kolla på skrivare och se deras beskrivningar, kan inte lägga beställningar 

Standardanvändare - inloggad. 
Kan allt gästanvändare kan, men kan även lägga beställningar och se sina tidigare. Kan ta bort sitt eget konto och information kopplat till det.

Adminanvändare 
Kan ta bort/editera skrivare, taggar och användare. kan se alla orders och användares information

## ER-Diagram

![Er-Diagram](./er_diagram.JPG?raw=true "ER-diagram")

## Gränssnittsskisser

**Login**

![Er-Diagram](./ui_login.png?raw=true "ER-diagram")

**Visa bok**

![Er-Diagram](./ui_show_book.png?raw=true "ER-diagram")