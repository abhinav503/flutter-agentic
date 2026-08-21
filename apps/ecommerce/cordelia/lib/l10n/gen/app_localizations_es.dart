// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get languageSheetTitle => 'Idioma';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'हिन्दी';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageItalian => 'Italiano';

  @override
  String unitPiecesLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'uds.',
      one: 'ud.',
    );
    return '$_temp0';
  }

  @override
  String get loginTitle => 'Te damos la bienvenida a CordeliaApps';

  @override
  String get loginSubtitle =>
      'Inicia sesión en tu cuenta con tu correo electrónico o tus redes sociales';

  @override
  String get emailLabel => 'Correo electrónico';

  @override
  String get emailHint => 'tu@ejemplo.com';

  @override
  String get passwordLabel => 'Contraseña';

  @override
  String get passwordHint => 'Introduce tu contraseña';

  @override
  String get forgotPasswordLabel => '¿Olvidaste tu contraseña?';

  @override
  String passwordResetEmailSentMessage(String email) {
    return 'Enlace para restablecer la contraseña enviado a $email';
  }

  @override
  String get continueLabel => 'Continuar';

  @override
  String get orLoginWith => 'O inicia sesión con';

  @override
  String get continueWithGoogle => 'Continuar con Google';

  @override
  String get continueWithApple => 'Continuar con Apple';

  @override
  String get byContinuingAgree => 'Al continuar, aceptas nuestros';

  @override
  String get termsOfServiceAndPrivacyPolicy =>
      'Términos del servicio y Política de privacidad';

  @override
  String get dontHaveAccount => '¿No tienes cuenta? ';

  @override
  String get signupLink => 'Regístrate';

  @override
  String get signupTitle => 'Crea tu cuenta';

  @override
  String get signupSubtitle => 'Introduce tus datos a continuación';

  @override
  String get nameLabel => 'Nombre';

  @override
  String get nameHint => 'p. ej. Mark Shelby';

  @override
  String get mobileLabel => 'Número de móvil';

  @override
  String get mobileHint => '(303) 555-0105';

  @override
  String get iAgreeLabel => 'Acepto los ';

  @override
  String get termsAndConditionsLink => 'Términos y condiciones';

  @override
  String get mustAgreeToTermsMessage =>
      'Debes aceptar los Términos y condiciones para continuar.';

  @override
  String get authWebUnsupportedMessage =>
      'El inicio de sesión solo está disponible en el móvil.';

  @override
  String get sessionExpiredMessage =>
      'Tu sesión ha caducado. Vuelve a iniciar sesión.';

  @override
  String get signupButtonLabel => 'Registrarse';

  @override
  String get alreadyHaveAccount => '¿Ya tienes cuenta? ';

  @override
  String get loginLink => 'Iniciar sesión';

  @override
  String get comingSoonMessage => 'Próximamente';

  @override
  String get deliveryUnavailableMessage =>
      'Esta tienda no realiza entregas en la dirección seleccionada.';

  @override
  String get paymentCancelledMessage => 'Pago cancelado';

  @override
  String couponMinOrderMessage(String price) {
    return 'Tu pedido está por debajo del mínimo de $price de este cupón';
  }

  @override
  String get paymentFailedMessage =>
      'No se ha podido completar el pago. Inténtalo de nuevo.';

  @override
  String get verifyEmailTitle => 'Verifica tu correo electrónico';

  @override
  String verifyEmailSubtitle(String email) {
    return 'Hemos enviado un enlace de verificación a $email. Ábrelo y vuelve aquí — esto se actualizará automáticamente.';
  }

  @override
  String get verifyEmailChecking => 'Comprobando…';

  @override
  String get resendEmailLabel => 'Reenviar correo';

  @override
  String get termsAndConditionsLabel => 'Términos y condiciones';

  @override
  String get privacyPolicyLabel => 'Política de privacidad';

  @override
  String get legalLastUpdatedLabel =>
      'Última actualización: 6 de agosto de 2026';

  @override
  String get termsAndConditionsIntro =>
      'Estas condiciones se aplican siempre que utilices la aplicación CordeliaApps. Léelas antes de comprar — crear una cuenta o realizar un pedido implica que las aceptas.';

  @override
  String get termsAndConditionsSection1Heading => '1. Quiénes somos';

  @override
  String get termsAndConditionsSection1Body =>
      'CordeliaApps desarrolla y opera esta aplicación de compras. Estamos radicados en la India y trabajamos con tiendas en la India, el Reino Unido, los Estados Unidos y toda Europa, por lo que la aplicación está disponible en varios idiomas y muestra los precios en la moneda propia de cada tienda. Si una traducción difiere de la versión en inglés, prevalece la versión en inglés.';

  @override
  String get termsAndConditionsSection2Heading =>
      '2. Nuestro papel — a quién le compras';

  @override
  String get termsAndConditionsSection2Body =>
      'CordeliaApps es la plataforma, no la tienda. Cada producto que ves lo publica, tarifa, vende y entrega la tienda que estás consultando, y tu contrato de compra es con esa tienda. No somos el vendedor ni cobramos el importe de los productos, así que las consultas sobre un pedido, un producto o un reembolso las atiende la tienda, y la aplicación es el medio para contactar con ella.';

  @override
  String get termsAndConditionsSection3Heading => '3. Tu cuenta';

  @override
  String get termsAndConditionsSection3Body =>
      'Necesitas una cuenta para comprar. Facilita datos exactos, verifica tu dirección de correo electrónico y no compartas tu contraseña — todo lo que se haga desde tu cuenta se considerará hecho por ti. Puedes eliminar tu cuenta en cualquier momento desde tu perfil. Tus pedidos anteriores permanecen con las tiendas que los atendieron, porque son sus propios registros comerciales.';

  @override
  String get termsAndConditionsSection4Heading => '4. Pedidos y pago';

  @override
  String get termsAndConditionsSection4Body =>
      'Realizar un pedido es una oferta de compra a la tienda. La tienda puede rechazarlo — por ejemplo si un artículo se ha agotado o no puede entregarse en tu dirección — y en ese caso te reembolsará el importe completo. Los precios los fija la tienda en su propia moneda e incluyen los impuestos aplicables, salvo que la tienda indique lo contrario. El pago lo cobra el proveedor de pagos de la tienda y se liquida a la tienda; CordeliaApps nunca retiene tu dinero.';

  @override
  String get termsAndConditionsSection5Heading =>
      '5. Entrega, cancelaciones y reembolsos';

  @override
  String get termsAndConditionsSection5Body =>
      'La tienda prepara y entrega tu pedido, y cualquier plazo de entrega mostrado es una estimación, no una promesa. Puedes cancelar un pedido en la aplicación mientras no se haya enviado, y la tienda te reembolsará al método de pago que utilizaste. Si procede un reembolso por cualquier otro motivo, también lo emite la tienda. Nada de esto reduce los derechos que te otorga tu legislación local.';

  @override
  String get termsAndConditionsSection6Heading =>
      '6. Información de productos y opiniones';

  @override
  String get termsAndConditionsSection6Body =>
      'Las tiendas redactan los nombres, descripciones, imágenes y precios de sus productos, de modo que esa información procede de la tienda y no de nosotros. Pueden producirse errores, y una tienda puede corregir un error o cancelar y reembolsar un pedido afectado. Si publicas una opinión, debe reflejar tu propia experiencia — conservas la titularidad de lo que escribes y nos autorizas, a nosotros y a la tienda, a mostrarlo en la aplicación. Podemos retirar contenido falso, ofensivo o contrario a estas condiciones.';

  @override
  String get termsAndConditionsSection7Heading => '7. Uso aceptable';

  @override
  String get termsAndConditionsSection7Body =>
      'Utiliza la aplicación para comprar y nada más. No realices pedidos fraudulentos, no crees cuentas ajenas, no recopiles datos de forma automatizada, no interfieras en su funcionamiento ni la uses con fines ilícitos. Podemos suspender o cerrar una cuenta que lo haga.';

  @override
  String get termsAndConditionsSection8Heading =>
      '8. Disponibilidad y nuestra responsabilidad';

  @override
  String get termsAndConditionsSection8Body =>
      'Trabajamos para que la aplicación funcione bien, pero no podemos garantizar que esté siempre disponible ni libre de fallos, y podemos modificar o retirar funciones. Somos responsables de la aplicación en sí. No somos responsables de los productos que vende una tienda, de la exactitud de lo que publica, ni de cómo gestiona tu pedido. Nada de lo aquí expuesto limita una responsabilidad que la ley no permita limitar.';

  @override
  String get termsAndConditionsSection9Heading =>
      '9. Ley aplicable y tus derechos locales';

  @override
  String get termsAndConditionsSection9Body =>
      'Estas condiciones se rigen por las leyes de la India y los tribunales de la India son competentes. Como prestamos servicio a compradores de otros países, esto no te priva de la protección de las normas imperativas de consumo del lugar donde resides. Si eres consumidor en el Reino Unido o en la Unión Europea, conservas tus derechos legales locales, incluido cualquier derecho de desistimiento dentro del plazo que fije tu legislación.';

  @override
  String get termsAndConditionsSection10Heading => '10. Cambios y contacto';

  @override
  String get termsAndConditionsSection10Body =>
      'Actualizamos estas condiciones a medida que la aplicación cambia, y la fecha que figura al principio de esta página indica la última modificación. Seguir usando la aplicación tras un cambio implica que aceptas las condiciones actualizadas. Si algo no te queda claro o necesitas ayuda con un pedido, escríbenos a support@cordeliaapps.com.';

  @override
  String get privacyPolicyIntro =>
      'Lee atentamente esta política de privacidad antes de usar nuestra aplicación.';

  @override
  String get privacyPolicySection1Heading => '1. Recogida de información';

  @override
  String get privacyPolicySection1Body =>
      'Recogemos la información imprescindible para mejorar tu experiencia. Incluye los datos que nos facilitas directamente, como los de tu cuenta, y también la información que obtenemos mediante analíticas de uso y cookies.';

  @override
  String get privacyPolicySection2Heading => '2. Uso de la información';

  @override
  String get privacyPolicySection2Body =>
      'La información recogida se utiliza para mejorar nuestros servicios, ofrecerte recomendaciones personalizadas y garantizar una experiencia fluida. No compartimos tus datos sin tu consentimiento expreso.';

  @override
  String get privacyPolicySection3Heading =>
      '3. Configuración de la información';

  @override
  String get privacyPolicySection3Body =>
      'Tienes el control total de tus datos. Gestiona tus preferencias de privacidad, actualiza tus datos personales y personaliza los ajustes según tus necesidades.';

  @override
  String get privacyPolicySection4Heading => '4. Medidas de seguridad';

  @override
  String get privacyPolicySection4Body =>
      'Damos prioridad a la seguridad de tus datos con protocolos avanzados, métodos de cifrado y auditorías periódicas para protegerlos frente a accesos no autorizados y filtraciones.';

  @override
  String get profilePageTitle => 'Perfil';

  @override
  String get changePasswordLabel => 'Cambiar contraseña';

  @override
  String get myOrdersLabel => 'Mis pedidos';

  @override
  String get myAddressLabel => 'Mis direcciones';

  @override
  String get darkModeLabel => 'Modo oscuro';

  @override
  String get logoutLabel => 'Cerrar sesión';

  @override
  String get logoutTitle => 'Cerrar sesión';

  @override
  String get logoutConfirmMessage => '¿Seguro que quieres cerrar sesión?';

  @override
  String get deleteAccountLabel => 'Eliminar cuenta';

  @override
  String get deleteAccountTitle => '¿Eliminar tu cuenta?';

  @override
  String get deleteAccountConfirmMessage =>
      'Esto elimina de forma permanente tu perfil, tus direcciones, tu carrito, tus favoritos y tus opiniones en todas las tiendas. Los pedidos que ya has realizado quedan en esas tiendas como registro de sus ventas. Esta acción no se puede deshacer.';

  @override
  String get deleteAccountFailedMessage =>
      'No se ha podido eliminar tu cuenta. Inténtalo de nuevo.';

  @override
  String get profileLoadErrorMessage =>
      'Se ha producido un error al cargar tu perfil.';

  @override
  String get sortRelevanceLabel => 'Relevancia';

  @override
  String get sortPriceLowToHighLabel => 'Precio (de menor a mayor)';

  @override
  String get sortPriceHighToLowLabel => 'Precio (de mayor a menor)';

  @override
  String get sortRatingHighToLowLabel => 'Valoración (de mayor a menor)';

  @override
  String get sortDiscountHighToLowLabel => 'Descuento (de mayor a menor)';

  @override
  String get priceFilterAllLabel => 'Todos los precios';

  @override
  String priceFilterUnderLabel(String price) {
    return 'Menos de $price';
  }

  @override
  String priceFilterOverLabel(String price) {
    return 'Más de $price';
  }

  @override
  String priceFilterRangeLabel(String from, String to) {
    return '$from - $to';
  }

  @override
  String get reviewsSectionTitle => 'Valoraciones y opiniones';

  @override
  String get writeReviewLabel => 'Escribir una opinión';

  @override
  String get editReviewLabel => 'Editar tu opinión';

  @override
  String get deleteReviewLabel => 'Eliminar';

  @override
  String get reviewSheetTitle => 'Valora este producto';

  @override
  String get reviewRatingPrompt => '¿Cuántas estrellas?';

  @override
  String get reviewTextLabel => 'Tu opinión';

  @override
  String get reviewTextHint => 'Cuenta a otros compradores qué te ha parecido…';

  @override
  String get reviewSubmitLabel => 'Enviar opinión';

  @override
  String get reviewMissingRatingMessage =>
      'Elige primero una valoración con estrellas.';

  @override
  String get reviewDeleteConfirmTitle => '¿Eliminar tu opinión?';

  @override
  String get reviewDeleteConfirmMessage =>
      'Esto retira tu valoración de la media del producto. Puedes escribir otra cuando quieras.';

  @override
  String get reviewSignedOutMessage =>
      'Inicia sesión para opinar sobre este producto.';

  @override
  String get verifiedPurchaseLabel => 'Compra verificada';

  @override
  String get reviewsEmptyTitle => 'Aún no hay opiniones';

  @override
  String get reviewsEmptySubtitle =>
      'Sé el primero en valorar este producto y ayuda a otros compradores a decidir.';

  @override
  String get unratedLabel => 'Aún no hay valoraciones';

  @override
  String get outOfStockLabel => 'Agotado';

  @override
  String onlyNLeftLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Solo quedan $count',
      one: 'Solo queda 1',
    );
    return '$_temp0';
  }

  @override
  String get cartUnavailableItemsMessage =>
      'Algunos artículos de tu carrito ya no están disponibles. Actualiza el carrito para continuar.';

  @override
  String productSoldOutMessage(String name) {
    return '$name se acaba de agotar. Actualiza el carrito para continuar.';
  }

  @override
  String productStockReducedMessage(String name) {
    return 'No queda suficiente $name. Actualiza el carrito para continuar.';
  }

  @override
  String get checkoutFailedMessage => 'No se pudo realizar tu pedido.';

  @override
  String get paymentRefundedNote => 'Se ha reembolsado tu pago.';

  @override
  String get rateOrderLabel => 'Valorar pedido';

  @override
  String get editOrderRatingLabel => 'Editar valoración';

  @override
  String get rateOrderSheetTitle => '¿Qué tal ha ido este pedido?';

  @override
  String get rateOrderTextLabel => 'Tu comentario';

  @override
  String get rateOrderTextHint => '¿Qué tal fue la entrega?';

  @override
  String get orderRatingNotDeliveredMessage =>
      'Puedes valorar un pedido cuando se haya entregado.';

  @override
  String get orderRatingFailedMessage =>
      'No se ha podido guardar tu valoración. Inténtalo de nuevo.';

  @override
  String get yourRatingLabel => 'Tu valoración';

  @override
  String orderPlacedAtLabel(String date, String time) {
    return '$date a las $time';
  }

  @override
  String reviewCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count opiniones',
      one: '$count opinión',
    );
    return '$_temp0';
  }

  @override
  String get reviewAgeJustNow => 'Ahora mismo';

  @override
  String reviewAgeMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'hace $count minutos',
      one: 'hace $count minuto',
    );
    return '$_temp0';
  }

  @override
  String reviewAgeHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'hace $count horas',
      one: 'hace $count hora',
    );
    return '$_temp0';
  }

  @override
  String reviewAgeDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'hace $count días',
      one: 'hace $count día',
    );
    return '$_temp0';
  }

  @override
  String reviewAgeMonthsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'hace $count meses',
      one: 'hace $count mes',
    );
    return '$_temp0';
  }

  @override
  String reviewAgeYearsAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'hace $count años',
      one: 'hace $count año',
    );
    return '$_temp0';
  }

  @override
  String get graviaCategoriesTitle => 'Todas las categorías';

  @override
  String get graviaSeeAll => 'Ver todo';

  @override
  String get graviaPopularItemsTitle => 'Artículos populares';

  @override
  String get graviaHomeLoadErrorMessage =>
      'No se pudo cargar el catálogo de esta tienda.';

  @override
  String get graviaCancel => 'Cancelar';

  @override
  String graviaDiscountPercentOff(String percent) {
    return '$percent% DTO.';
  }

  @override
  String get graviaAddToCart => 'Añadir al carrito';

  @override
  String get graviaAddToCartSheetTitle => 'Añadir al carrito';

  @override
  String get graviaDeleteLabel => 'Eliminar';

  @override
  String get graviaDeleteAddressTitle => 'Eliminar dirección';

  @override
  String get graviaDeleteAddressConfirmMessage =>
      '¿Seguro que quieres eliminar esta dirección? Esta acción no se puede deshacer.';

  @override
  String get graviaClearCartTitle => 'Vaciar carrito';

  @override
  String get graviaClearCartConfirmMessage =>
      '¿Seguro que quieres quitar todos los artículos de tu carrito?';

  @override
  String get graviaClearCartConfirmLabel => 'Vaciar carrito';

  @override
  String get graviaOrderPlacedTitle => 'Pedido realizado correctamente';

  @override
  String get graviaOrderPlacedSubtitle =>
      'Gracias por tu pedido, puedes seguir tu entrega en la sección de pedidos';

  @override
  String get graviaTrackYourOrderLabel => 'Seguir tu pedido';

  @override
  String get graviaSearchHint => 'Buscar';

  @override
  String get graviaNavHome => 'Inicio';

  @override
  String get graviaNavCategories => 'Categorías';

  @override
  String get graviaNavFavourite => 'Favoritos';

  @override
  String get graviaNavOrders => 'Pedidos';

  @override
  String get graviaNavProfile => 'Perfil';

  @override
  String get graviaRecentSearchTitle => 'Búsquedas recientes';

  @override
  String get graviaSearchLoadErrorMessage =>
      'Algo ha ido mal al cargar la búsqueda.';

  @override
  String get graviaSearchResultsErrorMessage => 'Algo ha ido mal al buscar.';

  @override
  String get graviaSearchCategoryBadge => 'Categoría';

  @override
  String get graviaSearchNoResultsTitle => 'No se han encontrado resultados';

  @override
  String graviaSearchNoResultsSubtitle(String query) {
    return 'Nada coincide con \"$query\". Prueba con otra palabra.';
  }

  @override
  String get graviaProductDetailsTitle => 'Detalles del producto';

  @override
  String get graviaSelectQtyLabel => 'Elegir cantidad';

  @override
  String get graviaKeyInformationTitle => 'Información clave';

  @override
  String get graviaReadMore => 'Leer más';

  @override
  String get graviaReadLess => 'Leer menos';

  @override
  String get graviaSimilarProductsTitle => 'Productos similares';

  @override
  String get graviaProductDetailsLoadErrorMessage =>
      'Algo ha ido mal al cargar este producto.';

  @override
  String graviaAddToCartWithPrice(String price) {
    return 'Añadir al carrito ($price)';
  }

  @override
  String get graviaCategoriesPageTitle => 'Categorías';

  @override
  String get graviaCategoriesLoadErrorMessage =>
      'Algo ha ido mal al cargar las categorías.';

  @override
  String get graviaCategoriesRefreshFailedMessage =>
      'No se pudo actualizar: mostrando las últimas categorías cargadas.';

  @override
  String get graviaSortLabel => 'Ordenar';

  @override
  String get graviaPriceLabel => 'Precio';

  @override
  String get graviaSortBySheetTitle => 'Ordenar por';

  @override
  String get graviaPriceSheetTitle => 'Precio';

  @override
  String get graviaCategoryDetailsEmptyMessage =>
      'Ningún producto coincide con estos filtros.';

  @override
  String get graviaSelectAddressTitle => 'Seleccionar dirección';

  @override
  String get graviaAddNewAddressLabel => 'Añadir nueva dirección';

  @override
  String get graviaDefaultAddressSectionTitle => 'Dirección predeterminada';

  @override
  String get graviaOtherAddressSectionTitle => 'Otras direcciones';

  @override
  String get graviaEditLabel => 'Editar';

  @override
  String get graviaAddressLoadErrorMessage =>
      'Algo ha ido mal al cargar tus direcciones.';

  @override
  String get graviaAddressSaveFailedMessage =>
      'No se pudo guardar la dirección. Inténtalo de nuevo.';

  @override
  String get graviaAddressDeleteFailedMessage =>
      'No se pudo eliminar la dirección. Inténtalo de nuevo.';

  @override
  String get graviaAddressEmptyTitle => 'No hay direcciones guardadas';

  @override
  String get graviaAddressEmptySubtitle =>
      'Añade tu primera dirección de entrega para empezar.';

  @override
  String get graviaEditAddressTitle => 'Editar dirección';

  @override
  String get graviaNameLabel => 'Nombre';

  @override
  String get graviaNameHint => 'p. ej. Mark Shelby';

  @override
  String get graviaPhoneNumberLabel => 'Número de teléfono';

  @override
  String get graviaPhoneNumberHint => 'p. ej. (303) 555-0105';

  @override
  String get graviaAddressLine1Label => 'Dirección, línea 1';

  @override
  String get graviaAddressLine1Hint => 'Número, nombre de la calle';

  @override
  String get graviaAddressLine2Label => 'Dirección, línea 2';

  @override
  String get graviaAddressLine2Hint => 'Piso, puerta, etc. (opcional)';

  @override
  String get graviaLandmarkLabel => 'Punto de referencia';

  @override
  String get graviaLandmarkHint => 'Punto de referencia cercano (opcional)';

  @override
  String get graviaCityLabel => 'Ciudad';

  @override
  String get graviaCityHint => 'p. ej. Nueva Delhi';

  @override
  String get graviaStateLabel => 'Provincia';

  @override
  String get graviaStateHint => 'p. ej. Delhi (opcional)';

  @override
  String get graviaCountryLabel => 'País';

  @override
  String get graviaSelectCountryTitle => 'Seleccionar país';

  @override
  String get graviaPostalCodeLabel => 'Código postal';

  @override
  String get graviaPostalCodeHint => 'p. ej. 62639';

  @override
  String get graviaAddressTagLabel => 'Etiqueta';

  @override
  String get graviaAddressTagHint => 'p. ej. Casa, Oficina';

  @override
  String get graviaAddAddressButtonLabel => 'Añadir dirección';

  @override
  String get graviaUpdateAddressButtonLabel => 'Actualizar dirección';

  @override
  String get graviaRequiredFieldErrorMessage => 'Este campo es obligatorio';

  @override
  String get graviaUseMyLocationLabel => 'Usar mi ubicación';

  @override
  String get graviaLocationUnavailableMessage =>
      'No se pudo obtener tu ubicación. Comprueba el permiso de ubicación e inténtalo de nuevo.';

  @override
  String get graviaAddressSearchLabel => 'Buscar dirección';

  @override
  String get graviaAddressSearchHint =>
      'Busca zona, calle, punto de referencia…';

  @override
  String get graviaProfilePageTitle => 'Perfil';

  @override
  String get graviaChangePasswordLabel => 'Cambiar contraseña';

  @override
  String get graviaMyOrdersLabel => 'Mis pedidos';

  @override
  String get graviaMyAddressLabel => 'Mis direcciones';

  @override
  String get graviaDarkModeLabel => 'Modo oscuro';

  @override
  String get graviaPrivacyPolicyLabel => 'Política de privacidad';

  @override
  String get graviaTermsAndConditionsLabel => 'Términos y condiciones';

  @override
  String get graviaLogoutLabel => 'Cerrar sesión';

  @override
  String get graviaLogoutTitle => 'Cerrar sesión';

  @override
  String get graviaLogoutConfirmMessage => '¿Seguro que quieres cerrar sesión?';

  @override
  String get graviaProfileLoadErrorMessage =>
      'Algo ha ido mal al cargar tu perfil.';

  @override
  String get graviaEditProfileTitle => 'Editar perfil';

  @override
  String get graviaEmailAddressLabel => 'Correo electrónico';

  @override
  String get graviaEmailAddressHint => 'p. ej. mark.shelby@example.com';

  @override
  String get graviaMobileNumberLabel => 'Número de móvil';

  @override
  String get graviaUpdateProfileButtonLabel => 'Actualizar';

  @override
  String get graviaChangePhotoTitle => 'Cambiar foto';

  @override
  String get graviaTakePhotoLabel => 'Hacer una foto';

  @override
  String get graviaChooseFromGalleryLabel => 'Elegir de la galería';

  @override
  String get graviaAvatarPickerMobileOnlyMessage =>
      'Cambiar tu foto solo está disponible en móvil';

  @override
  String get graviaChangePasswordTitle => 'Cambiar contraseña';

  @override
  String get graviaCurrentPasswordLabel => 'Contraseña actual';

  @override
  String get graviaCurrentPasswordHint => 'Introduce tu contraseña actual';

  @override
  String get graviaNewPasswordLabel => 'Nueva contraseña';

  @override
  String get graviaNewPasswordHint => 'Introduce tu nueva contraseña';

  @override
  String get graviaConfirmNewPasswordLabel => 'Confirmar nueva contraseña';

  @override
  String get graviaConfirmNewPasswordHint =>
      'Vuelve a introducir tu nueva contraseña';

  @override
  String get graviaUpdatePasswordButtonLabel => 'Actualizar contraseña';

  @override
  String get graviaPasswordUpdatedMessage => 'Tu contraseña se ha actualizado.';

  @override
  String get graviaMyCartTitle => 'Mi carrito';

  @override
  String get graviaBeforeYouCheckoutTitle => 'Antes de finalizar la compra';

  @override
  String get graviaCouponCodeLabel => 'Código de cupón';

  @override
  String get graviaApplyLabel => 'Aplicar';

  @override
  String get graviaCouponRemoveLabel => 'Quitar';

  @override
  String graviaCouponApplied(String code) {
    return '$code aplicado';
  }

  @override
  String graviaCouponLine(String code) {
    return 'Cupón ($code)';
  }

  @override
  String get graviaItemTotalLabel => 'Total de artículos';

  @override
  String get graviaDiscountLabel => 'Descuento';

  @override
  String get graviaDeliveryLabel => 'Entrega';

  @override
  String get graviaDeliveryFreeLabel => 'GRATIS';

  @override
  String get graviaGrandTotalLabel => 'Total general';

  @override
  String get graviaProceedToCheckoutLabel => 'Finalizar compra';

  @override
  String get graviaCartEmptyTitle => 'Tu carrito está vacío';

  @override
  String get graviaCartEmptySubtitle => 'Añade artículos para empezar.';

  @override
  String get graviaCartBarTitle => 'Ver más productos';

  @override
  String get graviaExploreLabel => 'Explorar';

  @override
  String get graviaCheckoutLabel => 'Finalizar compra';

  @override
  String graviaCartSummary(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count artículos',
      one: '$count artículo',
    );
    return '$_temp0 | $total';
  }

  @override
  String get graviaOrdersPageTitle => 'Pedidos';

  @override
  String get graviaUpcomingTabLabel => 'Activos';

  @override
  String get graviaPastTabLabel => 'Anteriores';

  @override
  String get graviaPendingStatusLabel => 'Pendiente';

  @override
  String get graviaInProcessStatusLabel => 'En camino';

  @override
  String get graviaDeliveredStatusLabel => 'Entregado';

  @override
  String get graviaCancelledStatusLabel => 'Cancelado';

  @override
  String get graviaDeliveryOtpLabel => 'OTP de entrega';

  @override
  String get graviaCancelOrderLabel => 'Cancelar';

  @override
  String get graviaTrackOrderLabel => 'Seguir';

  @override
  String get graviaViewDetailsLabel => 'Ver detalles';

  @override
  String get graviaWriteReviewLabel => 'Escribir una opinión';

  @override
  String get graviaRefundPendingLabel => 'En curso';

  @override
  String get graviaRefundProcessedLabel => 'Reembolsado';

  @override
  String get graviaRefundFailedLabel => 'Fallido';

  @override
  String get graviaCancelOrderConfirmTitle => '¿Cancelar este pedido?';

  @override
  String get graviaCancelOrderConfirmBody =>
      'Se cancelará tu pedido. Si has pagado, recibirás el reembolso completo.';

  @override
  String get graviaCancelOrderConfirmCta => 'Cancelar el pedido';

  @override
  String get graviaCancelOrderDismissCta => 'Mantener el pedido';

  @override
  String get graviaCancelFailedMessage =>
      'No se pudo cancelar el pedido. Inténtalo de nuevo.';

  @override
  String get graviaOrdersLoadErrorMessage =>
      'Algo ha ido mal al cargar tus pedidos.';

  @override
  String get graviaOrdersRefreshFailedMessage =>
      'No se pudo actualizar: mostrando los últimos pedidos cargados.';

  @override
  String get graviaTrackOrderTitle => 'Seguimiento del pedido';

  @override
  String get graviaOrderStatusTitle => 'Estado del pedido';

  @override
  String get graviaOrderItemsTitle => 'Artículos';

  @override
  String get graviaOrderSummaryTitle => 'Resumen';

  @override
  String get graviaOrderDetailsTitle => 'Detalles del pedido';

  @override
  String get graviaDeliveryAddressTitle => 'Dirección de entrega';

  @override
  String get graviaOrderIdLabel => 'ID del pedido';

  @override
  String get graviaOrderPlacedOnLabel => 'Realizado el';

  @override
  String get graviaPaymentIdLabel => 'ID del pago';

  @override
  String get graviaNoOnlinePaymentLabel => 'Sin pago online';

  @override
  String get graviaRefundLabel => 'Reembolso';

  @override
  String get graviaCopiedMessage => 'Copiado';

  @override
  String get graviaOrderTotalLabel => 'Total pagado';

  @override
  String get graviaOrderStepPlacedLabel => 'Pedido realizado';

  @override
  String get graviaOrderStepOnTheWayLabel => 'En camino';

  @override
  String get graviaOrderStepDeliveredLabel => 'Entregado';

  @override
  String get graviaOrderStepCancelledLabel => 'Cancelado';

  @override
  String get graviaOrderStepUndatedLabel => 'Hora no registrada';

  @override
  String get graviaOrdersEmptyTitle => 'Aún no hay pedidos';

  @override
  String get graviaOrdersEmptySubtitle =>
      'Tus pedidos anteriores y activos aparecerán aquí.';

  @override
  String get graviaFilterSheetTitle => 'Filtrar';

  @override
  String get graviaFilterReasonHeading => 'Selecciona un motivo';

  @override
  String get graviaFilterLastWeekLabel => '7 días';

  @override
  String get graviaFilterLastMonthLabel => '30 días';

  @override
  String get graviaFilterStatusLabel => 'Estado';

  @override
  String get graviaFilterDateLabel => 'Fecha';

  @override
  String get graviaFilterAllStatusesLabel => 'Todos';

  @override
  String get graviaApplyFilterLabel => 'Aplicar filtro';

  @override
  String get graviaFavouritePageTitle => 'Favoritos';

  @override
  String get graviaFavouriteEmptyTitle => 'Aún no hay favoritos';

  @override
  String get graviaFavouriteEmptySubtitle =>
      'Toca el corazón de un producto para guardarlo aquí.';

  @override
  String graviaAddedToCartMessage(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count × $name añadidos al carrito',
      one: '$name añadido al carrito',
    );
    return '$_temp0';
  }

  @override
  String get graviaDeliveryLocationLabel => 'Lugar de entrega';

  @override
  String get graviaNoLocationSelectedLabel => 'Sin ubicación seleccionada';

  @override
  String get graviaNotificationsTitle => 'Notificaciones';

  @override
  String get graviaNotificationsLoadErrorMessage =>
      'Algo ha ido mal al cargar tus notificaciones.';

  @override
  String get graviaNotificationsEmptyTitle => 'Aún no hay notificaciones';

  @override
  String get graviaNotificationsEmptySubtitle =>
      'Las novedades sobre tus pedidos y tu cuenta aparecerán aquí.';

  @override
  String get dailymartTopSellerTitle => 'Más vendidos🔥';

  @override
  String get dailymartCategoriesTitle => 'Compra por categoría';

  @override
  String get dailymartPopularProductsTitle => 'Productos populares';

  @override
  String get dailymartSeeAll => 'Ver todo';

  @override
  String get dailymartSearchHint => 'Buscar productos';

  @override
  String get dailymartHomeLoadErrorMessage =>
      'No se pudo cargar el catálogo de esta tienda.';

  @override
  String get dailymartNoLocationSelectedLabel => 'Selecciona una ubicación';

  @override
  String get dailymartNotificationsTitle => 'Notificaciones';

  @override
  String get dailymartNotificationsLoadErrorMessage =>
      'No se pudieron cargar tus notificaciones.';

  @override
  String get dailymartNotificationsEmptyTitle => 'Aún no hay notificaciones';

  @override
  String get dailymartNotificationsEmptySubtitle =>
      'Las ofertas y las novedades de tus pedidos de esta tienda aparecerán aquí.';

  @override
  String get dailymartOrderNow => 'Pide ahora';

  @override
  String dailymartPromoSubtitle(String percent) {
    return 'Hasta un $percent% de descuento\nen tu pedido de hoy';
  }

  @override
  String dailymartDiscountPercentOff(String percent) {
    return '$percent% dto.';
  }

  @override
  String get dailymartNavHome => 'Inicio';

  @override
  String get dailymartNavWishlist => 'Favoritos';

  @override
  String get dailymartNavCart => 'Carrito';

  @override
  String get dailymartNavProfile => 'Perfil';

  @override
  String get dailymartRecentSearchTitle => 'Búsquedas recientes';

  @override
  String get dailymartRecentlyViewedTitle => 'Vistos recientemente';

  @override
  String dailymartResultsForLabel(String query) {
    return 'Resultados de \"$query\"';
  }

  @override
  String dailymartResultsCountLabel(int count) {
    return '$count resultados';
  }

  @override
  String get dailymartSearchLoadErrorMessage =>
      'No se pudo cargar la búsqueda.';

  @override
  String get dailymartSearchResultsErrorMessage =>
      'No se pudo buscar en esta tienda.';

  @override
  String get dailymartSearchNoResultsTitle => 'Sin resultados';

  @override
  String dailymartSearchNoResultsSubtitle(String query) {
    return 'Todavía no hay nada en esta tienda que coincida con \"$query\".';
  }

  @override
  String get dailymartCategoryBadge => 'Categoría';

  @override
  String get dailymartFilterLabel => 'Filtrar';

  @override
  String get dailymartSortSheetTitle => 'Ordenar por';

  @override
  String get dailymartPriceSheetTitle => 'Precio';

  @override
  String get dailymartCategoryDetailsEmptyTitle => 'Nada por aquí';

  @override
  String get dailymartCategoryDetailsEmptySubtitle =>
      'Ningún producto de esta categoría coincide con esos filtros.';

  @override
  String get dailymartCategoryDetailsErrorMessage =>
      'No se pudo cargar esta categoría.';

  @override
  String get dailymartWishlistEmptyTitle => 'Aún no has guardado nada';

  @override
  String get dailymartWishlistEmptySubtitle =>
      'Toca el corazón de un producto y te esperará aquí.';

  @override
  String get dailymartWishlistExploreAction => 'Empezar a comprar';

  @override
  String get dailymartProductDetailsTitle => 'Detalles del producto';

  @override
  String get dailymartDescriptionsTabLabel => 'Descripción';

  @override
  String get dailymartReviewsTabLabel => 'Opiniones';

  @override
  String get dailymartRelatedProductsTitle => 'Productos relacionados';

  @override
  String get dailymartSelectSizeLabel => 'Elige el tamaño';

  @override
  String get dailymartProductDetailsLoadErrorMessage =>
      'No se pudieron cargar los detalles de este producto.';

  @override
  String get dailymartAddToCart => 'Añadir al carrito';

  @override
  String get dailymartAddToCartSheetTitle => 'Añadir al carrito';

  @override
  String dailymartAddedToCartMessage(int count, String name) {
    return 'Añadido a tu carrito: $count × $name.';
  }

  @override
  String dailymartStarRowLabel(int stars) {
    return '$stars estrellas';
  }

  @override
  String get dailymartMyCartTitle => 'Mi carrito';

  @override
  String get dailymartCouponHint => 'Introduce el código de cupón';

  @override
  String get dailymartCouponRemoveLabel => 'Quitar';

  @override
  String get dailymartCouponDetailLabel => 'Cupón';

  @override
  String dailymartCouponApplied(String code) {
    return '$code aplicado';
  }

  @override
  String dailymartCouponLine(String code) {
    return 'Cupón ($code)';
  }

  @override
  String get dailymartSubTotalLabel => 'Subtotal';

  @override
  String get dailymartDeliveryLabel => 'Entrega';

  @override
  String get dailymartDeliveryFreeLabel => 'Gratis';

  @override
  String get dailymartDiscountLabel => 'Descuento';

  @override
  String get dailymartTotalCostLabel => 'Coste total';

  @override
  String get dailymartProceedToCheckoutLabel => 'Finalizar compra';

  @override
  String get dailymartCartEmptyTitle => 'Tu carrito está vacío';

  @override
  String get dailymartCartEmptySubtitle =>
      'Los productos que añadas aparecerán aquí, listos para comprar.';

  @override
  String get dailymartCartExploreAction => 'Empezar a comprar';

  @override
  String get dailymartRemovedFromCartMessage => 'Eliminado de tu carrito.';

  @override
  String get dailymartCheckoutTitle => 'Finalizar compra';

  @override
  String get dailymartShippingAddressLabel => 'Dirección de envío';

  @override
  String get dailymartOrderListLabel => 'Lista del pedido';

  @override
  String get dailymartContinueToPaymentLabel => 'Continuar al pago';

  @override
  String get dailymartOrderPlacedTitle => '¡Pago realizado!';

  @override
  String get dailymartOrderPlacedMessage =>
      '¡Gracias por tu compra! Nos alegra decirte que tu pago se ha procesado correctamente. 🎉';

  @override
  String get dailymartTrackOrderLabel => 'Seguir mi pedido';

  @override
  String dailymartCartSummary(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count artículos',
      one: '$count artículo',
    );
    return '$_temp0 | $total';
  }

  @override
  String get dailymartViewCartLabel => 'Ver carrito';

  @override
  String get dailymartGeneralSectionTitle => 'General';

  @override
  String get dailymartPreferencesSectionTitle => 'Preferencias';

  @override
  String get dailymartEditProfileLabel => 'Editar perfil';

  @override
  String get dailymartChangePasswordLabel => 'Cambiar contraseña';

  @override
  String get dailymartMyOrdersLabel => 'Mis pedidos';

  @override
  String get dailymartMyAddressLabel => 'Mis direcciones';

  @override
  String get dailymartDarkModeLabel => 'Modo oscuro';

  @override
  String get dailymartPrivacyPolicyLabel => 'Política de privacidad';

  @override
  String get dailymartTermsAndConditionsLabel => 'Términos y condiciones';

  @override
  String get dailymartLogoutLabel => 'Cerrar sesión';

  @override
  String get dailymartLogoutTitle => '¿Cerrar sesión?';

  @override
  String get dailymartLogoutConfirmMessage =>
      'Tendrás que iniciar sesión de nuevo para hacer un pedido o seguirlo.';

  @override
  String get dailymartProfileLoadErrorMessage => 'No se pudo cargar tu perfil.';

  @override
  String get dailymartEditProfileTitle => 'Editar perfil';

  @override
  String get dailymartFullNameLabel => 'Nombre completo';

  @override
  String get dailymartFullNameHint => 'Introduce tu nombre completo';

  @override
  String get dailymartEmailLabel => 'Correo electrónico';

  @override
  String get dailymartEmailHint => 'tu@ejemplo.com';

  @override
  String get dailymartPhoneNumberLabel => 'Número de teléfono';

  @override
  String get dailymartPhoneNumberHint => 'Introduce tu número de teléfono';

  @override
  String get dailymartSaveChangesLabel => 'Guardar cambios';

  @override
  String get dailymartChangePhotoTitle => 'Cambiar foto';

  @override
  String get dailymartTakePhotoLabel => 'Hacer una foto';

  @override
  String get dailymartChooseFromGalleryLabel => 'Elegir de la galería';

  @override
  String get dailymartAvatarPickerMobileOnlyMessage =>
      'Elegir una foto solo está disponible en el móvil.';

  @override
  String get dailymartChangePasswordTitle => 'Cambiar contraseña';

  @override
  String get dailymartCurrentPasswordLabel => 'Contraseña actual';

  @override
  String get dailymartCurrentPasswordHint => 'Introduce tu contraseña actual';

  @override
  String get dailymartNewPasswordLabel => 'Nueva contraseña';

  @override
  String get dailymartNewPasswordHint => 'Introduce tu nueva contraseña';

  @override
  String get dailymartConfirmNewPasswordLabel => 'Confirmar nueva contraseña';

  @override
  String get dailymartConfirmNewPasswordHint =>
      'Vuelve a introducir tu nueva contraseña';

  @override
  String get dailymartUpdatePasswordButtonLabel => 'Actualizar contraseña';

  @override
  String get dailymartPasswordUpdatedMessage =>
      'Tu contraseña se ha actualizado.';

  @override
  String get dailymartSelectAddressTitle => 'Seleccionar dirección';

  @override
  String get dailymartAddNewAddressLabel => 'Añadir nueva dirección';

  @override
  String get dailymartAddressLoadErrorMessage =>
      'No se pudieron cargar tus direcciones.';

  @override
  String get dailymartAddressSaveFailedMessage =>
      'No se pudo guardar esa dirección.';

  @override
  String get dailymartAddressEmptyTitle => 'Sin direcciones guardadas';

  @override
  String get dailymartAddressEmptySubtitle =>
      'Añade una para que esta tienda entregue en tu puerta.';

  @override
  String get dailymartAddressDeleteFailedMessage =>
      'No se pudo eliminar esa dirección.';

  @override
  String get dailymartEditAddressTooltip => 'Editar dirección';

  @override
  String get dailymartDeleteAddressTitle => '¿Eliminar esta dirección?';

  @override
  String get dailymartDeleteAddressMessage =>
      'Se quitará de tus direcciones guardadas.';

  @override
  String get dailymartDeleteLabel => 'Eliminar';

  @override
  String get dailymartAddAddressTitle => 'Añadir nueva dirección';

  @override
  String get dailymartEditAddressTitle => 'Editar dirección';

  @override
  String get dailymartAddressNameLabel => 'Nombre';

  @override
  String get dailymartAddressNameHint => 'p. ej. Mark Shelby';

  @override
  String get dailymartAddressLine1Label => 'Dirección línea 1';

  @override
  String get dailymartAddressLine1Hint => 'Número, nombre de la calle';

  @override
  String get dailymartAddressLine2Label => 'Dirección línea 2';

  @override
  String get dailymartAddressLine2Hint => 'Piso, puerta, etc. (opcional)';

  @override
  String get dailymartLandmarkLabel => 'Punto de referencia';

  @override
  String get dailymartLandmarkHint => 'Punto de referencia cercano (opcional)';

  @override
  String get dailymartCityLabel => 'Ciudad';

  @override
  String get dailymartCityHint => 'p. ej. Nueva Delhi';

  @override
  String get dailymartStateLabel => 'Provincia';

  @override
  String get dailymartStateHint => 'p. ej. Delhi (opcional)';

  @override
  String get dailymartCountryLabel => 'País';

  @override
  String get dailymartSelectCountryTitle => 'Seleccionar país';

  @override
  String get dailymartPostalCodeLabel => 'Código postal';

  @override
  String get dailymartPostalCodeHint => 'p. ej. 62639';

  @override
  String get dailymartAddressTagLabel => 'Etiqueta';

  @override
  String get dailymartAddressTagHint => 'p. ej. Casa, Oficina';

  @override
  String get dailymartAddAddressButtonLabel => 'Añadir dirección';

  @override
  String get dailymartUpdateAddressButtonLabel => 'Actualizar dirección';

  @override
  String get dailymartRequiredFieldErrorMessage => 'Este campo es obligatorio';

  @override
  String get dailymartMyOrdersTitle => 'Mis pedidos';

  @override
  String get dailymartOrdersSearchHint => '¿Qué estás buscando...?';

  @override
  String get dailymartOrdersFilterAllLabel => 'Todos';

  @override
  String get dailymartOrdersFilterActiveLabel => 'Activos';

  @override
  String get dailymartOrdersFilterCompletedLabel => 'Completados';

  @override
  String get dailymartOrdersFilterCancelledLabel => 'Cancelados';

  @override
  String dailymartOrderSummaryLabel(int count, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count artículos',
      one: '$count artículo',
    );
    return '$_temp0 · $date';
  }

  @override
  String get dailymartOrdersDateRangeLabel => 'Rango de fechas';

  @override
  String get dailymartOrdersAllTimeLabel => 'Todo';

  @override
  String get dailymartOrdersFilterLastWeekLabel => '7 días';

  @override
  String get dailymartOrdersFilterLastMonthLabel => '30 días';

  @override
  String get dailymartResetLabel => 'Restablecer';

  @override
  String get dailymartApplyLabel => 'Aplicar';

  @override
  String get dailymartOrdersLoadErrorMessage =>
      'No se pudieron cargar tus pedidos.';

  @override
  String get dailymartOrdersEmptyTitle => 'Aún no hay pedidos';

  @override
  String get dailymartOrdersEmptySubtitle =>
      'Tus pedidos de esta tienda aparecerán aquí.';

  @override
  String get dailymartOrdersNoResultsTitle => 'Nada por aquí';

  @override
  String get dailymartOrdersNoResultsSubtitle =>
      'Ningún pedido coincide con esa búsqueda o filtro.';

  @override
  String get dailymartOrderCancelFailedMessage =>
      'No se pudo cancelar ese pedido.';

  @override
  String get dailymartOrdersRefreshFailedMessage =>
      'No se pudieron actualizar tus pedidos.';

  @override
  String get dailymartTrackOrderTitle => 'Seguimiento del pedido';

  @override
  String get dailymartTrackOrderAction => 'Seguir';

  @override
  String get dailymartOrderDetailsTitle => 'Detalles del pedido';

  @override
  String get dailymartOrderIdLabel => 'ID del pedido';

  @override
  String get dailymartDeliveryOtpLabel => 'OTP de entrega';

  @override
  String get dailymartPaymentTitle => 'Pago';

  @override
  String get dailymartAmountPaidLabel => 'Importe pagado';

  @override
  String get dailymartPaymentIdLabel => 'ID del pago';

  @override
  String get dailymartRefundLabel => 'Reembolso';

  @override
  String get dailymartCopiedMessage => 'Copiado';

  @override
  String get dailymartNoOnlinePaymentLabel => 'No pagado online';

  @override
  String get dailymartRefundPendingLabel => 'En curso';

  @override
  String get dailymartRefundProcessedLabel => 'Reembolsado';

  @override
  String get dailymartRefundFailedLabel => 'Fallido';

  @override
  String get dailymartOrderStatusTitle => 'Estado del pedido';

  @override
  String get dailymartOrderStepPlacedLabel => 'Realizado';

  @override
  String get dailymartOrderStepOnTheWayLabel => 'En camino';

  @override
  String get dailymartOrderStepDeliveredLabel => 'Entregado';

  @override
  String get dailymartOrderStepCancelledLabel => 'Cancelado';

  @override
  String get dailymartOrderStepUndatedLabel => 'Hora no registrada';

  @override
  String get dailymartOrderStepPendingLabel => 'Pendiente';

  @override
  String get dailymartCancelOrderLabel => 'Cancelar';

  @override
  String get dailymartCancelOrderTitle => '¿Cancelar este pedido?';

  @override
  String get dailymartCancelOrderMessage =>
      'Si el pedido estaba pagado, te reembolsaremos el importe.';

  @override
  String get dailymartCancelOrderConfirmLabel => 'Cancelar el pedido';

  @override
  String get dailymartCancelLabel => 'Cancelar';

  @override
  String grofastGreeting(String name) {
    return '¡Hola $name! 👋';
  }

  @override
  String get grofastGreetingFallbackName => 'de nuevo';

  @override
  String get grofastGreetingSubtitle => 'Encuentra productos frescos';

  @override
  String get grofastSearchHint => 'Busca productos frescos';

  @override
  String get grofastCategoriesTitle => 'Categorías';

  @override
  String get grofastPopularTitle => 'Popular';

  @override
  String get grofastSeeAll => 'ver todo';

  @override
  String get grofastHomeLoadErrorMessage =>
      'No se pudo cargar el catálogo de esta tienda.';

  @override
  String get grofastNoLocationSelectedLabel => 'Elige una ubicación';

  @override
  String get grofastClaimNow => 'canjear ya';

  @override
  String grofastPromoDiscountLabel(String percent) {
    return '$percent dto.';
  }

  @override
  String get grofastCategoriesLoadErrorMessage =>
      'No se pudieron cargar las categorías.';

  @override
  String get grofastCategoriesEmptyTitle => 'Aún no hay categorías';

  @override
  String get grofastCategoriesEmptySubtitle =>
      'Esta tienda no ha publicado ninguna categoría.';

  @override
  String grofastCategoryProductsTitle(String category) {
    return 'Todo en $category';
  }

  @override
  String get grofastCategoryDetailsEmptyTitle => 'Aún no hay nada aquí';

  @override
  String get grofastCategoryDetailsEmptySubtitle =>
      'Ahora mismo no hay productos en esta categoría.';

  @override
  String get grofastCategoryDetailsErrorMessage =>
      'No se pudo cargar esta categoría.';

  @override
  String get grofastSearchTitle => 'Buscar productos';

  @override
  String get grofastRecentSearchTitle => 'Búsquedas recientes';

  @override
  String grofastResultsCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count resultados encontrados',
      one: '$count resultado encontrado',
    );
    return '$_temp0';
  }

  @override
  String get grofastSearchLoadErrorMessage => 'No se pudo cargar la búsqueda.';

  @override
  String get grofastSearchResultsErrorMessage =>
      'No se pudo buscar en esta tienda.';

  @override
  String get grofastSearchNoResultsTitle => 'Sin resultados';

  @override
  String grofastSearchNoResultsSubtitle(String query) {
    return 'Nada coincide con \"$query\". Prueba con otra palabra.';
  }

  @override
  String get grofastSearchIdleTitle => '¿Qué estás buscando?';

  @override
  String get grofastSearchIdleSubtitle =>
      'Busca en toda la tienda por nombre o categoría.';

  @override
  String get grofastSortByTitle => 'Ordenar por';

  @override
  String get grofastPriceTitle => 'Precio';

  @override
  String get grofastApplyLabel => 'Aplicar';

  @override
  String get grofastResetLabel => 'Restablecer';

  @override
  String get grofastAddToBagTooltip => 'Añadir al carrito';

  @override
  String get grofastFavouriteTooltip => 'Guardar en favoritos';

  @override
  String get grofastDecreaseQuantityLabel => 'Reducir cantidad';

  @override
  String get grofastIncreaseQuantityLabel => 'Aumentar cantidad';

  @override
  String get grofastProductDetailsTitle => 'Detalles del producto';

  @override
  String get grofastDescriptionTitle => 'Descripción';

  @override
  String get grofastSelectSizeTitle => 'Elige el tamaño';

  @override
  String get grofastAddToBag => 'Añadir al carrito';

  @override
  String get grofastProductDetailsLoadErrorMessage =>
      'Ahora mismo no se pudo cargar este producto.';

  @override
  String grofastAddedToBagMessage(int count, String name) {
    return 'Se han añadido $count × $name a tu carrito.';
  }

  @override
  String get grofastNoDescriptionLabel =>
      'Este producto aún no tiene descripción.';

  @override
  String get grofastBagTitle => 'Mi carrito';

  @override
  String grofastBagItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count artículos',
      one: '$count artículo',
    );
    return '$_temp0';
  }

  @override
  String get grofastPromoCodeHint => 'Añadir código promocional';

  @override
  String get grofastPromoApplyLabel => 'Aplicar';

  @override
  String get grofastPromoRemoveLabel => 'Quitar';

  @override
  String get grofastCouponDetailLabel => 'Cupón';

  @override
  String grofastPromoApplied(String code) {
    return '$code aplicado';
  }

  @override
  String grofastCouponLine(String code) {
    return 'Cupón ($code)';
  }

  @override
  String get grofastPromoComingSoonMessage =>
      'Los códigos promocionales estarán disponibles próximamente.';

  @override
  String get grofastTotalLabel => 'Total';

  @override
  String get grofastSubtotalLabel => 'Subtotal';

  @override
  String get grofastDeliveryLabel => 'Entrega';

  @override
  String get grofastDeliveryFreeLabel => 'Gratis';

  @override
  String get grofastDiscountLabel => 'Descuento';

  @override
  String get grofastProceedToCheckoutLabel => 'Finalizar compra';

  @override
  String get grofastBagEmptyTitle => 'Tu carrito está vacío';

  @override
  String get grofastBagEmptySubtitle =>
      'Añade productos frescos y aparecerán aquí.';

  @override
  String get grofastBagExploreAction => 'Empezar a comprar';

  @override
  String get grofastRemovedFromBagMessage => 'Eliminado de tu carrito.';

  @override
  String get grofastCheckoutTitle => 'Finalizar compra';

  @override
  String get grofastItemsTitle => 'Artículos';

  @override
  String get grofastDeliveryAddressTitle => 'Dirección de entrega';

  @override
  String get grofastAddNewLabel => 'añadir nueva';

  @override
  String get grofastChangeAddressLabel => 'cambiar';

  @override
  String get grofastNoAddressSelectedLabel => 'Elige dónde entregarlo';

  @override
  String get grofastConfirmOrderLabel => 'Confirmar pedido';

  @override
  String get grofastOrderPlacedTitle => '¡Listo!';

  @override
  String get grofastOrderPlacedMessage =>
      'Tu pedido se ha creado correctamente.';

  @override
  String get grofastBrowseHomeLabel => 'Ir al inicio';

  @override
  String get grofastNavHome => 'Inicio';

  @override
  String get grofastNavCategories => 'Categorías';

  @override
  String get grofastNavBag => 'Carrito';

  @override
  String get grofastNavAccount => 'Perfil';

  @override
  String get grofastProfileTitle => 'Perfil';

  @override
  String get grofastNotificationTileLabel => 'Notificaciones';

  @override
  String get grofastOrdersTileLabel => 'Mis pedidos';

  @override
  String get grofastWishlistTileLabel => 'Favoritos';

  @override
  String get grofastMyProfileLabel => 'Mi perfil';

  @override
  String get grofastChangePasswordLabel => 'Cambiar contraseña';

  @override
  String get grofastDarkModeLabel => 'Modo oscuro';

  @override
  String get grofastMyAddressLabel => 'Mis direcciones';

  @override
  String get grofastPrivacyPolicyLabel => 'Política de privacidad';

  @override
  String get grofastTermsAndConditionsLabel => 'Términos y condiciones';

  @override
  String get grofastLogOutLabel => 'Cerrar sesión';

  @override
  String get grofastLogOutTitle => '¿Cerrar sesión?';

  @override
  String get grofastLogOutConfirmMessage =>
      'Tendrás que iniciar sesión de nuevo para hacer un pedido.';

  @override
  String get grofastProfileLoadErrorMessage => 'No se pudo cargar tu perfil.';

  @override
  String get grofastProfileNameFallback => 'Tu cuenta';

  @override
  String get grofastEditProfileTitle => 'Mi perfil';

  @override
  String get grofastFullNameLabel => 'Nombre completo';

  @override
  String get grofastFullNameHint => 'Introduce tu nombre completo';

  @override
  String get grofastEmailLabel => 'Correo electrónico';

  @override
  String get grofastEmailHint => 'tu@ejemplo.com';

  @override
  String get grofastPhoneNumberLabel => 'Número de teléfono';

  @override
  String get grofastPhoneNumberHint => 'Introduce tu número de teléfono';

  @override
  String get grofastSaveChangesLabel => 'Guardar cambios';

  @override
  String get grofastChangePhotoTitle => 'Cambiar foto';

  @override
  String get grofastTakePhotoLabel => 'Hacer una foto';

  @override
  String get grofastChooseFromGalleryLabel => 'Elegir de la galería';

  @override
  String get grofastAvatarPickerMobileOnlyMessage =>
      'Elegir fotos solo está disponible en el móvil.';

  @override
  String get grofastProfileUpdatedMessage => 'Tu perfil se ha actualizado.';

  @override
  String get grofastChangePasswordTitle => 'Cambiar contraseña';

  @override
  String get grofastCurrentPasswordLabel => 'Contraseña actual';

  @override
  String get grofastCurrentPasswordHint => 'Introduce tu contraseña actual';

  @override
  String get grofastNewPasswordLabel => 'Contraseña nueva';

  @override
  String get grofastNewPasswordHint => 'Introduce tu contraseña nueva';

  @override
  String get grofastConfirmNewPasswordLabel => 'Confirmar contraseña nueva';

  @override
  String get grofastConfirmNewPasswordHint =>
      'Vuelve a introducir tu contraseña nueva';

  @override
  String get grofastUpdatePasswordButtonLabel => 'Actualizar contraseña';

  @override
  String get grofastPasswordUpdatedMessage =>
      'Tu contraseña se ha actualizado.';

  @override
  String get grofastWishlistTitle => 'Favoritos';

  @override
  String get grofastWishlistEmptyTitle => 'Aún no has guardado nada';

  @override
  String get grofastWishlistEmptySubtitle =>
      'Toca el corazón en lo que quieras guardar para más tarde.';

  @override
  String get grofastWishlistExploreAction => 'Empezar a comprar';

  @override
  String get grofastNotificationsTitle => 'Notificaciones';

  @override
  String get grofastNotificationsFilterAllLabel => 'Todas';

  @override
  String get grofastNotificationsSearchHint => 'Busca en tus notificaciones';

  @override
  String get grofastNotificationsNowTitle => 'Ahora';

  @override
  String get grofastNotificationsPastTitle => 'Anteriores';

  @override
  String get grofastNotificationsLoadErrorMessage =>
      'No se pudieron cargar tus notificaciones.';

  @override
  String get grofastNotificationsEmptyTitle => 'Aún no hay notificaciones';

  @override
  String get grofastNotificationsEmptySubtitle =>
      'Te avisaremos cuando haya novedades sobre tus pedidos.';

  @override
  String get grofastNotificationsNoResultsTitle => 'Aquí no hay nada';

  @override
  String grofastNotificationsNoResultsSubtitle(String query) {
    return 'Ninguna notificación coincide con \"$query\".';
  }

  @override
  String get grofastSelectAddressTitle => 'Elegir ubicación';

  @override
  String get grofastAddNewAddressLabel => 'Añadir dirección';

  @override
  String get grofastAddressLoadErrorMessage =>
      'No se pudieron cargar tus direcciones.';

  @override
  String get grofastAddressEmptyTitle => 'No hay direcciones guardadas';

  @override
  String get grofastAddressEmptySubtitle =>
      'Añade una para saber dónde llevarte la compra.';

  @override
  String get grofastAddressSaveFailedMessage =>
      'No se pudo guardar esa dirección.';

  @override
  String get grofastAddressDeleteFailedMessage =>
      'No se pudo eliminar esa dirección.';

  @override
  String get grofastEditAddressTooltip => 'Editar dirección';

  @override
  String get grofastDeleteAddressTitle => '¿Eliminar esta dirección?';

  @override
  String get grofastDeleteAddressMessage =>
      'Se quitará de tus ubicaciones guardadas. Esta acción no se puede deshacer.';

  @override
  String get grofastDeleteLabel => 'Eliminar';

  @override
  String get grofastCancelLabel => 'Cancelar';

  @override
  String get grofastAddAddressTitle => 'Añadir dirección';

  @override
  String get grofastEditAddressTitle => 'Editar dirección';

  @override
  String get grofastAddressNameLabel => 'Nombre';

  @override
  String get grofastAddressNameHint => 'p. ej. Yona Angela';

  @override
  String get grofastAddressLine1Label => 'Dirección línea 1';

  @override
  String get grofastAddressLine1Hint => 'Número, nombre de la calle';

  @override
  String get grofastAddressLine2Label => 'Dirección línea 2';

  @override
  String get grofastAddressLine2Hint => 'Piso, puerta, etc. (opcional)';

  @override
  String get grofastLandmarkLabel => 'Punto de referencia';

  @override
  String get grofastLandmarkHint => 'Punto de referencia cercano (opcional)';

  @override
  String get grofastCityLabel => 'Ciudad';

  @override
  String get grofastCityHint => 'p. ej. Bengaluru';

  @override
  String get grofastStateLabel => 'Provincia';

  @override
  String get grofastStateHint => 'p. ej. Karnataka (opcional)';

  @override
  String get grofastCountryLabel => 'País';

  @override
  String get grofastSelectCountryTitle => 'Elegir país';

  @override
  String get grofastPostalCodeLabel => 'Código postal';

  @override
  String get grofastPostalCodeHint => 'p. ej. 62639';

  @override
  String get grofastAddressTagLabel => 'Etiqueta';

  @override
  String get grofastAddressTagHint => 'p. ej. Casa, Oficina';

  @override
  String get grofastMobileLabel => 'Número de móvil';

  @override
  String get grofastMobileHint => 'Dónde podemos localizarte';

  @override
  String get grofastAddAddressButtonLabel => 'Añadir dirección';

  @override
  String get grofastUpdateAddressButtonLabel => 'Actualizar dirección';

  @override
  String get grofastRequiredFieldErrorMessage => 'Este campo es obligatorio';

  @override
  String get grofastMyOrdersTitle => 'Mis pedidos';

  @override
  String get grofastOrdersSearchHint => 'Busca en tus pedidos';

  @override
  String get grofastOrdersFilterAllLabel => 'Todos';

  @override
  String get grofastOrdersFilterActiveLabel => 'En camino';

  @override
  String get grofastOrdersFilterCompletedLabel => 'Entregado';

  @override
  String get grofastOrdersFilterCancelledLabel => 'Cancelado';

  @override
  String get grofastOrdersDateFilterTitle => 'Filtrar por fecha';

  @override
  String get grofastOrdersDateRangeLabel => 'Intervalo de fechas';

  @override
  String get grofastOrdersAllTimeLabel => 'Todo';

  @override
  String get grofastOrdersFilterLastWeekLabel => '7 días';

  @override
  String get grofastOrdersFilterLastMonthLabel => '30 días';

  @override
  String get grofastOrdersLoadErrorMessage =>
      'No se pudieron cargar tus pedidos.';

  @override
  String get grofastOrdersRefreshFailedMessage =>
      'No se pudieron actualizar tus pedidos.';

  @override
  String get grofastOrdersEmptyTitle => 'Aún no hay pedidos';

  @override
  String get grofastOrdersEmptySubtitle =>
      'Tus pedidos aparecerán aquí cuando hagas el primero.';

  @override
  String get grofastOrdersNoResultsTitle => 'Aquí no hay nada';

  @override
  String get grofastOrdersNoResultsSubtitle =>
      'Ningún pedido coincide con esos filtros. Prueba a ampliarlos.';

  @override
  String grofastOrderNumberLabel(String date) {
    return 'Pedido $date';
  }

  @override
  String grofastOrderItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count artículos',
      one: '$count artículo',
    );
    return '$_temp0';
  }

  @override
  String grofastOrderDeliveredLine(String label) {
    return 'Entregado en $label';
  }

  @override
  String grofastOrderDeliveringLine(String label) {
    return 'En camino a $label';
  }

  @override
  String get grofastOrderCancelledLine => 'Este pedido se canceló';

  @override
  String get grofastTrackOrderTitle => 'Seguimiento del pedido';

  @override
  String get grofastOrderDetailTitle => 'Detalle del pedido';

  @override
  String get grofastCopyTooltip => 'Copiar';

  @override
  String grofastCopiedMessage(String label) {
    return '$label copiado.';
  }

  @override
  String get grofastTrackingDetailTitle => 'Detalle del seguimiento';

  @override
  String get grofastOrderStatusLabel => 'Estado';

  @override
  String get grofastPurchaseDateLabel => 'Fecha de compra';

  @override
  String get grofastOrderIdLabel => 'ID del pedido';

  @override
  String get grofastDeliveryOtpLabel => 'OTP de entrega';

  @override
  String get grofastPaymentIdLabel => 'ID del pago';

  @override
  String get grofastAmountPaidLabel => 'Importe pagado';

  @override
  String get grofastNoOnlinePaymentLabel => 'No pagado online';

  @override
  String get grofastRefundLabel => 'Reembolso';

  @override
  String get grofastOrderReceivedLabel => 'Pedido recibido';

  @override
  String get grofastCancelOrderLabel => 'Cancelar';

  @override
  String get grofastCancelOrderTitle => '¿Cancelar este pedido?';

  @override
  String get grofastCancelOrderMessage =>
      'Te reembolsaremos lo que hayas pagado. Esta acción no se puede deshacer.';

  @override
  String get grofastCancelOrderConfirmLabel => 'Cancelar el pedido';

  @override
  String get grofastOrderCancelFailedMessage =>
      'No se pudo cancelar ese pedido.';

  @override
  String get grofastOrderStepUndatedLabel => 'Hora no registrada';

  @override
  String get grofastOrderStepPendingLabel => 'Pendiente';

  @override
  String get grofastStatusPlacedLabel => 'Realizado';

  @override
  String get grofastStatusOnDeliveryLabel => 'En camino';

  @override
  String get grofastStatusDeliveredLabel => 'Entregado';

  @override
  String get grofastStatusCancelledLabel => 'Cancelado';

  @override
  String get grofastRefundPendingLabel => 'En curso';

  @override
  String get grofastRefundProcessedLabel => 'Reembolsado';

  @override
  String get grofastRefundFailedLabel => 'Fallido';

  @override
  String get validationNameRequired => 'Introduce tu nombre.';

  @override
  String get validationEmailRequired => 'Introduce tu correo electrónico.';

  @override
  String get validationEmailInvalid =>
      'Introduce un correo electrónico válido.';

  @override
  String get validationMobileRequired => 'Introduce tu número de móvil.';

  @override
  String get validationMobileInvalid => 'Introduce un número de móvil válido.';

  @override
  String get validationPasswordRequired => 'Introduce tu contraseña.';

  @override
  String get validationWeakPassword =>
      'La contraseña debe tener al menos 6 caracteres.';

  @override
  String get validationConfirmPasswordRequired =>
      'Confirma tu nueva contraseña.';

  @override
  String get validationPasswordsDontMatch => 'Las contraseñas no coinciden.';

  @override
  String get retryButton => 'Reintentar';

  @override
  String get notificationsSectionToday => 'Hoy';

  @override
  String get notificationsSectionYesterday => 'Ayer';

  @override
  String get notificationsSectionEarlier => 'Antes';

  @override
  String get notificationsPermissionTitle =>
      'Las notificaciones están desactivadas';

  @override
  String get notificationsPermissionSubtitle =>
      'Actívalas para recibir novedades de tus pedidos y ofertas de esta tienda.';

  @override
  String get notificationsPermissionCta => 'Activar notificaciones';

  @override
  String get notificationsPermissionBlockedMessage =>
      'Las notificaciones están bloqueadas para CordeliaApps. Actívalas en los ajustes de tu dispositivo.';
}
