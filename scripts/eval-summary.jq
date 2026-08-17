def metric($name):
  map(.[$name]) as $values
  | {
      mean: (($values | add) / ($values | length)),
      min: ($values | min),
      max: ($values | max)
    };

{
  installable: $installable,
  platform: $platform,
  warmups: $warmups,
  runs: length,
  metrics: {
    wallSeconds: metric("wallSeconds"),
    cpuSeconds: metric("cpuSeconds"),
    maxRssBytes: metric("maxRssBytes"),
    evaluatorBytes: metric("evaluatorBytes"),
    gcBytes: metric("gcBytes"),
    values: metric("values"),
    functionCalls: metric("functionCalls"),
    primopCalls: metric("primopCalls"),
    thunks: metric("thunks"),
    lookups: metric("lookups")
  }
}
