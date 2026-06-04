# Known Limitations

The API client is mocked and does not yet call the FastAPI server from Flutter.

Hive uses map storage instead of generated typed adapters to keep the assessment lightweight.

No APK is included; use the README build instructions.

Sync conflict resolution is simulated and should be replaced by server-side queue acknowledgements for production.
