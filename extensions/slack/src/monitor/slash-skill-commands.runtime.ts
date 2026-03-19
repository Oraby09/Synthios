import { listSkillCommandsForAgents as listSkillCommandsForAgentsImpl } from "synthios/plugin-sdk/reply-runtime";

type ListSkillCommandsForAgents =
  typeof import("synthios/plugin-sdk/reply-runtime").listSkillCommandsForAgents;

export function listSkillCommandsForAgents(
  ...args: Parameters<ListSkillCommandsForAgents>
): ReturnType<ListSkillCommandsForAgents> {
  return listSkillCommandsForAgentsImpl(...args);
}
