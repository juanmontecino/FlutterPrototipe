# Flutter app

### Hecha por Agustin Santicchia, Axel Rust, Juan Cruz Montecino y Santiago Mangas

Abrir el menu lateral para navegar mediante las screens de los participantes.
Toda la informacion esta siendo siendo obtenida mediante peticiones http a localhost:3000.

## Juan Cruz Montecino (News Screen)
📱 Descripción General
La pantalla de noticias ofrece una experiencia completa para explorar noticias del mundo en tiempo real. Esta sección de la aplicación permite a los usuarios mantenerse informados sobre diversos temas, con una interfaz intuitiva y funcionalidades de búsqueda avanzadas.

### 🚀 Características Principales

📰 Visualización de Noticias

- Tarjetas informativas con imágenes destacadas
- Información detallada incluyendo fuente, fecha y descripción
- Actualización en tiempo real de las últimas noticias

🔍 Sistema de Búsqueda

- Barra de búsqueda con filtrado instantáneo
- Búsqueda por palabras clave

🎯 Navegación y Usabilidad

- Barra de navegación inferior para acceso rápido
- Indicadores de carga para mejor feedback
- Función de "pull to refresh" para actualizar contenido

💻 Aspectos Técnicos
- Provider Pattern para gestión de estado
- Sistema de caché para optimización
- Manejo eficiente de recursos
- API Integration en tiempo real

Componentes Principales
- NewsProvider: Gestión de estado y datos
- NewsListScreen: Visualización principal
- NewsCard: Componente de tarjeta de noticia
- SearchProvider: Lógica de búsqueda y filtrado

## Axel Rust (Canciones Screen)
En la seccion de canciones, es posible ver las canciones mas destacadas, realizar la busqueda de una cancion, poder agregar a favoritos y ver en una lista diferente las canciones favoritas. Tambien incluye una seccion que permite filtrar por genero

## Santiago Manuel Mangas Willging (Pokemon Screen)
## 📖 Pokédex en Flutter  
En esta pantalla se muestra un listado de Pokémon con datos extreidos de la API en Node. Al hacer clic en un Pokémon, puedes ver sus detalles en la vista pokemon_details_view. El color de fondo dependerá del tipo de Pokémon, según lo definido en el archivo de la carpeta utils.
Si seleccionas el apartado de "Notas del entrenador", se mostrará el widget pokemon_form_view, que incluye un formulario ficticio. En este formulario puedes indicar si atrapaste al Pokémon y si es shiny. En caso de que lo hayas capturado, debes asignarle un nombre y, opcionalmente, agregar ciertas notas. Estas notas se pueden guardar.
## 🚀 **Características**
- Listado paginado de Pokémon  
- Búsqueda por número de Pokédex  
- Gestión de estado con **Provider**  
- Configuración de tema oscuro/claro  
- Persistencia con **SharedPreferences**  
- Uso de **`.env`** para configuración flexible

2️⃣ Configurar el archivo .env en la raíz del proyecto:

API_URL=http://localhost:3000

🔍 Sistema de Búsqueda

- Barra de búsqueda con filtrado instantáneo
- Búsqueda por ID (numero de la pokedex)

## 📚Agustin Santicchia (Libros Screen)

*La **Biblioteca Virtual** permite a los usuarios **explorar, buscar y gestionar libros de manera intuitiva y eficiente**.*

## ✨ Funcionalidades  

### 🔍 **Exploración y Visualización**  
- Muestra una lista de libros con **título, autor e imagen de portada**.  
- Cada libro puede ser seleccionado para ver más detalles.  

### 🛠 **Funciones Avanzadas**  
- **Búsqueda inteligente** por título o autor.  
- **Vista de detalles** con descripción completa e imagen ampliada.  
- **Marcado de libros como leídos o no leídos** para llevar un registro de lectura.  

### 🎨 **Diseño Moderno y Optimizado**  
- Interfaz atractiva y fácil de usar.  
- Adaptable a distintos tamaños de pantalla y dispositivos.  
