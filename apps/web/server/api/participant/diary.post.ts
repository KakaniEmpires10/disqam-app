import { saveSleepDiary, sleepDiaryInput } from '../../services/sleep-diary'

export default adminEndpoint(async (event) => {
  const participant = await requireParticipant(event)
  return { entry: await saveSleepDiary(participant.id, sleepDiaryInput(await readParticipantBody(event))) }
})
