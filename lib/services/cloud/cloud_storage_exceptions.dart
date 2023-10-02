class CloudStorageExceptions implements Exception {
  const CloudStorageExceptions();
}

class CouldNotCreateNoteException extends CloudStorageExceptions {}
class CouldNotGetAllNoteException extends CloudStorageExceptions{}
class CouldNotUpdateNoteException extends CloudStorageExceptions{}
class CouldNotDeleteNoteException extends CloudStorageExceptions{}
