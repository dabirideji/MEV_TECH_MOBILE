// Certificate

String certificateCreate = '/api/Certificate/Create';
String certificateDelete = '/api/Certificate/Delete/{id}';
String certificateGetAll = '/api/Certificate/GetAll';
String certificateGetByCourseId = '/api/Certificate/GetByCourseId/{courseId}';
String cert(String courseId) => '/api/Certificate/GetByCourseId/$courseId';

String certificateGetById = '/api/Certificate/GetById/{id}';
String certificateUpdate = '/api/Certificate/Update';
