import { listSleepDiaries } from '../../services/sleep-diary'

export default adminEndpoint(async (event) => {
  const participant = await requireParticipant(event)
  return { entries: await listSleepDiaries(participant.id) }
})
