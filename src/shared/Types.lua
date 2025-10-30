export type userid = number
export type uuid = string

export type Party = {
    id: uuid,
    leader: userid,
    name: string,
    members: {userid}
}

return ""