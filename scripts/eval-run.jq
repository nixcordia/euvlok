{
  platform: $platform,
  run: $run,
  wallSeconds: $wallSeconds,
  cpuSeconds: .cpuTime,
  maxRssBytes: $maxRssBytes,
  peakFootprintBytes: $peakFootprintBytes,
  evaluatorBytes: (
    [.envs.bytes, .list.bytes, .sets.bytes, .values.bytes] | add
  ),
  gcBytes: .gc.totalBytes,
  values: .values.number,
  functionCalls: .nrFunctionCalls,
  primopCalls: .nrPrimOpCalls,
  thunks: .nrThunks,
  lookups: .nrLookups
}
