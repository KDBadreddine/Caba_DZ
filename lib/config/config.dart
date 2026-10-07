/// Server URLs — fill these before connecting the app to the backend.
/// Same pattern as the other app: one website, one API root, one CRUD endpoint.

const String website = 'https://api.sup-apps.com';

const String generalServer = '$website/api/v1';

/// Single CRUD gateway. Every request POSTs JSON:
/// `{ action, table, options | data | conditions }`.
const String endpoint = '$generalServer/endpoint';

/// Public files / uploaded images.
const String uploadsUrl = '$website/uploads';
