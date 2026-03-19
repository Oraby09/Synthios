import type { SynthiosConfig } from "../../config/types.js";

export type DirectoryConfigParams = {
  cfg: SynthiosConfig;
  accountId?: string | null;
  query?: string | null;
  limit?: number | null;
};
