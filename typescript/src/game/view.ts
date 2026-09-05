/**
 * The shape of what `Core.view()` hands over, and the events that come with it.
 *
 * These mirror `crates/goset-core/src/view.rs` and `event.rs`. They are hand
 * written rather than generated because there are two dozen fields and a
 * generator would be a build step to maintain for no more safety than this:
 * `cargo test` builds the view for all 140 streets, and the end-to-end suite
 * plays the game, so a field that stops matching shows up in both.
 */

export type State = "title" | "map" | "play" | "win";

export interface TrackButton {
  id: string;
  label: string;
  item: string;
  cleared: number;
  total: number;
  lit: boolean;
}

export interface QuestTab {
  index: number;
  tag: string;
  station: string;
  cleared: number;
  total: number;
  lit: boolean;
}

export interface StationView {
  station: string;
  id: string;
  name: string;
  title: string;
  lesson: string;
  cleared: boolean;
}

export interface NpcView {
  kind: string;
  x: number;
  facing: number;
  line: string;
}

export interface MapView {
  id: string;
  station: string;
  name: string;
  title: string;
  lesson: string;
  story: string;
  speaker: string;
  bg: string;
  portrait: string;
  viz: string;
  ground: number;
  width: number;
  npcs: NpcView[];
  chips: Array<[string, string]>;
  note: string;
}

export interface CodeLine {
  text: string;
  blank: boolean;
}

export interface StageView {
  topic: string;
  question: string;
  hint: string;
  answer: string;
  code: CodeLine[];
}

export interface StatsView {
  level: number;
  xp: number;
  into: number;
  size: number;
  badges: number;
}

export interface WinView {
  stamp: string;
  bg: string;
  title: string;
  head: string;
}

export interface ContinueView {
  questTag: string;
  station: string;
  cleared: number;
  total: number;
}

export interface View {
  version: number;
  state: State;
  lang: string;
  langName: string;

  track: string;
  trackLabel: string;
  tracks: TrackButton[];
  questTag: string;
  questStation: string;
  questName: string;
  questNumber: number;
  questTabs: QuestTab[];

  step: number;
  stage: number;
  stageCount: number;
  stations: StationView[];
  clearedCount: number;
  allCleared: boolean;

  map: MapView;
  stageData: StageView;

  input: string;
  solved: boolean;
  hintLevel: number;
  msg: string;
  msgKind: "idle" | "ok" | "bad";
  streak: number;
  perfect: boolean;

  mapCursor: number;
  mapFrom: State;
  canResume: boolean;

  stats: StatsView;
  win: WinView;
  continueAt: ContinueView | null;

  auto: boolean;
  sheet: boolean;
  shareScope: "street" | "quest" | "track";
}

/** `[player x, facing, walking, camera, clock]`. */
export type Anim = Float32Array;

export type Space = "screen" | "scene";

export type CoreEvent =
  | { event: "sfx"; name: string; pitch: number }
  | { event: "burst"; at: Space; fx: number; fy: number; n: number }
  | { event: "shake"; amount: number }
  | { event: "flash"; good: boolean; amount: number }
  | { event: "fx_small"; fx: number; fy: number; text: string }
  | { event: "fx_big"; text: string; perfect: boolean }
  | { event: "fx_quest"; text: string }
  | { event: "fx_clear" }
  | { event: "pop"; text: string; kind: PopKind }
  | { event: "pops_clear" }
  | { event: "save" }
  | { event: "copy"; text: string }
  | { event: "download"; name: string; mime: string; body: string }
  | { event: "toast"; text: string };

export type PopKind = "combo" | "xp" | "perfect" | "level" | "badge";
