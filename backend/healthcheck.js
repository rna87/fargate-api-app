import { get } from "http";

get(`${process.env.SERVER_URL}/health`, (resp) => {
    if (resp.statusCode === 200) process.exit(0);
    else process.exit(1);
});